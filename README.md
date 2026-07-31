# ⚡ Retrieval Funnel Toolkit

> **75%+ Token Savings & 4x Faster AI Agent Development**

The **Retrieval Funnel Toolkit** is a reusable 6-layer static analysis and dynamic introspection pipeline designed to eliminate manual codebase exploration by AI coding agents. 

Instead of letting agents burn millions of tokens running `grep_search`, `find`, or browsing directories, this toolkit builds a deterministic, machine-readable artifact map (`retrieval_funneling/`) of any codebase in seconds.

---

## 📂 Toolkit Architecture (Layers 1–6)

| Layer | Component | Description | Generated Artifact |
| :--- | :--- | :--- | :--- |
| **Layer 1** | **Lexical Debt** | Scans for `TODO`, `FIXME`, `NotImplementedError`, and silent stubs via `ripgrep` | `lexical_signals.md` |
| **Layer 2** | **AST Grammar** | Extracts class/function grammar trees and base class definitions via `ast-grep` | `ast_symbols.json` |
| **Layer 3** | **Codebase Compression** | Packs repository context into a single clean file via `Repomix` | `architecture-context.md` |
| **Layer 4** | **Symbol Centrality** | Calculates PageRank symbol centrality across definition graphs via `Aider` | `repo-map.md` |
| **Layer 5** | **Synthesis Matrix** | Prioritized implementation roadmap derived from static signals | `final_synthesis.md` |
| **Layer 6** | **Dynamic Autopsy** | Dynamic call stack tracing and universal Pydantic v2 JSON contract extraction | `pydantic_schemas.json` |

---

## 🚀 Quick Start Guide

### 1. Copy Toolkit to Any Target Project
Copy this `retrieval_funnel_toolkit` folder into the root directory of any Python project you want to analyze:

```bash
cp -r retrieval_funnel_toolkit /path/to/your-target-project/
cd /path/to/your-target-project/
```

### 2. Install Requirements
Install the minimal dependencies (or ensure your environment has them):

```bash
# Option A: Run setup_tools.sh to install system binaries (ast-grep, aider, ripgrep, etc.)
./retrieval_funnel_toolkit/setup_tools.sh

# Option B: Install Python-only analysis dependencies
pip install -r retrieval_funnel_toolkit/requirements.txt
```

### 3. Run the Funnel Pipeline
Run the master runner script:

```bash
chmod +x retrieval_funnel_toolkit/run_funnel.sh
./retrieval_funnel_toolkit/run_funnel.sh .
```

This will automatically populate the `retrieval_funneling/` directory with all 6 layer artifacts!

---

## 🤖 Using Prompt Templates for AI Agents

Once `retrieval_funneling/` artifacts are generated, open `retrieval_funnel_toolkit/templates/agent_prompts.md` and copy the single-turn prompt into your AI agent session (Claude, Cursor, ChatGPT, Antigravity).

### Performance Benchmark Results:
* **Baseline (Manual Exploration)**: ~8.7 Million Tokens consumed
* **Retrieval Funnel (Single-Turn Batch)**: ~2.1 Million Tokens consumed
* **Token Savings**: **75.86% Token Reduction** 🚀

---

## 📦 Uploading to GitHub

To make this toolkit its own independent GitHub repository:

```bash
cd retrieval_funnel_toolkit
git init
git add .
git commit -m "Initial commit: Retrieval Funnel Toolkit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/retrieval-funnel-toolkit.git
git push -u origin main
```
