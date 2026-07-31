#!/usr/bin/env python3
"""
Universal Pydantic Schema Extractor for Retrieval Funneling (Layer 6)
Dynamically discovers and introspects Pydantic v2 BaseModel definitions across any Python repository.
"""

import os
import sys
import json
import importlib
import inspect
from pathlib import Path
from typing import Dict, Any, List, Set

def ensure_sys_path(target_root: Path):
    """Ensure project target root and src directories are in sys.path for dynamic imports."""
    str_root = str(target_root.resolve())
    if str_root not in sys.path:
        sys.path.insert(0, str_root)
    src_dir = str((target_root / "src").resolve())
    if os.path.exists(src_dir) and src_dir not in sys.path:
        sys.path.insert(0, src_dir)

def find_target_modules(target_root: Path) -> Set[str]:
    """Discover Python module import paths using ast_symbols.json or file tree scan."""
    modules = set()
    ast_symbols_path = target_root / "retrieval_funneling" / "ast_symbols.json"
    
    # Strategy 1: AST Symbols JSON
    if ast_symbols_path.exists():
        try:
            with open(ast_symbols_path, "r", encoding="utf-8") as f:
                data = json.load(f)
                for item in data:
                    rel_path = item.get("file", "")
                    if rel_path.endswith(".py"):
                        mod_name = path_to_module(rel_path)
                        if mod_name:
                            modules.add(mod_name)
        except Exception as e:
            print(f"[Warning] Failed to parse ast_symbols.json: {e}")

    # Strategy 2: File System Fallback
    if not modules:
        search_dirs = [target_root / "src", target_root]
        for s_dir in search_dirs:
            if s_dir.exists():
                for py_file in s_dir.rglob("*.py"):
                    if not any(part.startswith(".") or part in ("venv", ".venv", "node_modules", "tests", "dist", "build") for part in py_file.parts):
                        rel = py_file.relative_to(target_root)
                        mod = path_to_module(str(rel))
                        if mod:
                            modules.add(mod)
    return modules

def path_to_module(file_path: str) -> str:
    """Convert relative file path to Python import dot-notation."""
    p = Path(file_path)
    parts = list(p.parts)
    if parts and parts[0] == "src":
        parts = parts[1:]
    if not parts:
        return ""
    if parts[-1].endswith(".py"):
        parts[-1] = parts[-1][:-3]
    return ".".join(parts)

def extract_schemas(target_root: Path) -> Dict[str, Any]:
    """Dynamically import discovered modules and extract Pydantic BaseModel JSON Schemas."""
    ensure_sys_path(target_root)
    modules = find_target_modules(target_root)
    schemas = {}

    try:
        from pydantic import BaseModel
    except ImportError:
        print("[Error] Pydantic is not installed in the active environment.")
        return {}

    for mod_name in sorted(modules):
        try:
            mod = importlib.import_module(mod_name)
            for attr_name, obj in inspect.getmembers(mod):
                if (
                    inspect.isclass(obj)
                    and issubclass(obj, BaseModel)
                    and obj is not BaseModel
                    and obj.__module__ == mod_name
                ):
                    try:
                        if hasattr(obj, "model_json_schema"):
                            schemas[f"{mod_name}.{attr_name}"] = obj.model_json_schema()
                        elif hasattr(obj, "schema"):
                            schemas[f"{mod_name}.{attr_name}"] = obj.schema()
                    except Exception as err:
                        print(f"[Warning] Could not extract schema for {attr_name}: {err}")
        except Exception as e:
            # Silently skip modules with unsatisfied runtime dependencies
            continue

    return schemas

def main():
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path.cwd()
    output_dir = root / "retrieval_funneling"
    output_dir.mkdir(exist_ok=True)
    out_file = output_dir / "pydantic_schemas.json"

    print(f"Extracting Pydantic schemas from root: {root}")
    schemas = extract_schemas(root)

    with open(out_file, "w", encoding="utf-8") as f:
        json.dump(schemas, f, indent=2)

    print(f"Successfully extracted {len(schemas)} Pydantic schema(s) into -> {out_file}")

if __name__ == "__main__":
    main()
