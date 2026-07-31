# 🎯 Retrieval Funneling Agent Prompt Templates

This document contains the production-proven prompt templates for running AI coding agents (Claude, GPT-4o, Gemini, Cursor, Aider, Antigravity) with **75%+ Token Savings** using your generated `retrieval_funneling/` artifacts.

---

## 🚀 Prompt 1: Single-Turn Retrieval Funnel Prompt (Maximum Token Efficiency)

Use this prompt when you want the AI agent to read the `retrieval_funneling/` artifacts first, then batch **all file edits and test creations into a single execution turn** before running pytest.

```markdown
I have a `retrieval_funneling` directory containing pre-synthesized context about my codebase. I want you to implement and verify the "[INSERT FEATURE NAME / PRIORITY TARGET]" feature as identified in `retrieval_funneling/final_synthesis.md`.

### **Step 1: Context & File Target Identification**
**Do not use grep or search tools.** You MUST read the following retrieval funneling files first to understand target locations, class signatures, and architectural insights:
1. `retrieval_funneling/final_synthesis.md` (for the task description and priority)
2. `retrieval_funneling/layer6_discovery.md` (for dynamic intercept points and call stacks)
3. `retrieval_funneling/lexical_signals.md` (for technical debt / stub locations)
4. `retrieval_funneling/structural_signals.md` (for class skeletons and signatures)

### **CRITICAL EFFICIENCY RULE (Single Execution Turn for Edits)**
Once you have read the artifacts above, **perform ALL code modifications and unit test creation simultaneously in a single execution turn**. Do not pause between edits or run intermediate interactive REPL loops.

### **Step 2: Single-Turn Implementation & Test Creation**
Based on the context read from the artifacts, perform all of the following in **one single turn**:
1. Update target source files identified from the artifacts.
2. Create dedicated unit tests in `tests/` covering core logic and edge cases.

### **Step 3: Verification**
Execute `pytest tests/` to confirm all tests pass successfully.
```

---

## ⚡ Prompt 2: Zero-Shot Distilled Prompt (Lowest Token Cost)

Use this prompt when you want to inject the pre-extracted targets directly into the initial prompt, skipping artifact reading turns entirely:

```markdown
I have a `retrieval_funneling` directory containing pre-synthesized context about my codebase. I want you to implement the following feature:

### Context & Targets (Extracted from Retrieval Funnel Artifacts)
- **Target File 1 (`[PATH]`)**: [INSTRUCTIONS / LOGIC]
- **Target File 2 (`[PATH]`)**: [INSTRUCTIONS / LOGIC]
- **Test File (`tests/test_[FEATURE].py`)**: Create unit tests covering edge cases.

### Execution Instructions:
1. Execute all edits and test file creation **simultaneously in your first response turn**.
2. Immediately run `pytest tests/test_[FEATURE].py` to confirm all tests pass.
```
