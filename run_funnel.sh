#!/usr/bin/env bash
# ==============================================================================
# Retrieval Funnel Toolkit - Master Runner
# Executes Layers 1-6 of the Retrieval Funneling Pipeline on any target Python project.
# ==============================================================================

set -e

TARGET_DIR="${1:-.}"
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)
OUTPUT_DIR="${TARGET_DIR}/retrieval_funneling"

echo "======================================================================"
echo "🚀 Initializing Retrieval Funnel Pipeline on: $TARGET_DIR"
echo "======================================================================"

mkdir -p "$OUTPUT_DIR"

# Layer 1: Lexical Debt Search (ripgrep)
echo "[1/6] Running Layer 1: Lexical Debt Search..."
if command -v rg >/dev/null 2>&1; then
    rg -n -i 'TODO|FIXME|HACK|XXX|WIP|STUB|not implemented|missing|incomplete|placeholder' \
       --glob '!{.venv,venv,node_modules,dist,build,.git,*.json,*.lock}*' "$TARGET_DIR" > "$OUTPUT_DIR/lexical_signals.md" || true
    echo "  └─ Saved -> $OUTPUT_DIR/lexical_signals.md"
else
    echo "  └─ [Skip] ripgrep (rg) not installed."
fi

# Layer 2: Structural AST Grammar (ast-grep)
echo "[2/6] Running Layer 2: Structural AST Grammar..."
if command -v ast-grep >/dev/null 2>&1; then
    ast-grep run --json -p 'class $NAME($$$BASES): $$$BODY' "$TARGET_DIR/src" > "$OUTPUT_DIR/ast_symbols.json" 2>/dev/null || \
    ast-grep run --json -p 'class $NAME($$$BASES): $$$BODY' "$TARGET_DIR" > "$OUTPUT_DIR/ast_symbols.json" 2>/dev/null || true
    echo "  └─ Saved -> $OUTPUT_DIR/ast_symbols.json"
else
    echo "  └─ [Skip] ast-grep not installed."
fi

# Layer 3: Semantic Codebase Context (Repomix)
echo "[3/6] Running Layer 3: Codebase Compression (Repomix)..."
if command -v npx >/dev/null 2>&1; then
    npx --yes repomix@latest --compress --style markdown "$TARGET_DIR" \
        --ignore "**/.venv/**,**/venv/**,**/node_modules/**,**/dist/**,**/build/**,**/*.json,**/*.lock" \
        -o "$OUTPUT_DIR/architecture-context.md" >/dev/null 2>&1 || true
    echo "  └─ Saved -> $OUTPUT_DIR/architecture-context.md"
else
    echo "  └─ [Skip] npx / repomix not available."
fi

# Layer 4: Centrality & Symbol Graph (Aider Repo-Map)
echo "[4/6] Running Layer 4: Centrality Symbol Mapping (Aider)..."
if command -v aider >/dev/null 2>&1; then
    (cd "$TARGET_DIR" && echo "n" | aider --show-repo-map > "$OUTPUT_DIR/repo-map.md" 2>/dev/null || true)
    echo "  └─ Saved -> $OUTPUT_DIR/repo-map.md"
else
    echo "  └─ [Skip] aider not installed."
fi

# Layer 5: Synthesis Matrix Placeholder
echo "[5/6] Generating Layer 5 Synthesis Matrix..."
cat << 'EOF' > "$OUTPUT_DIR/final_synthesis.md"
# Layer 5: Synthesis Matrix

| Priority | Feature / Debt Target | Supporting Layers | Target File | Effort |
| :--- | :--- | :--- | :--- | :--- |
| P0 | Core Feature Implementation | Layer 1 Debt + Layer 4 PageRank | TBD | Medium |
EOF
echo "  └─ Saved -> $OUTPUT_DIR/final_synthesis.md"

# Layer 6: Dynamic Introspection & Schema Extraction
echo "[6/6] Running Layer 6: Universal Pydantic Schema Extraction..."
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$TARGET_DIR/.venv/bin/python" ]; then
    "$TARGET_DIR/.venv/bin/python" "$SCRIPT_DIR/scripts/extract_schemas.py" "$TARGET_DIR"
elif command -v uv >/dev/null 2>&1; then
    uv run python "$SCRIPT_DIR/scripts/extract_schemas.py" "$TARGET_DIR"
else
    python3 "$SCRIPT_DIR/scripts/extract_schemas.py" "$TARGET_DIR"
fi

echo "======================================================================"
echo "✅ Retrieval Funneling Complete! Artifacts generated in:"
echo "   $OUTPUT_DIR"
echo "======================================================================"
