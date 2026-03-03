# IOE-DEV: Autonomous Lisp Machine with AI Operator

## Overview

IOE-DEV is an autonomous Lisp machine that combines:
- **IISCV**: Immutable and Curated Version Control with forensic auditing
- **LISA**: Expert system rules engine for code quality validation
- **MCP Server**: Model Context Protocol for AI agent communication
- **Kilo**: AI coding agent that operates on the live Lisp image

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Kilo (AI Agent)                         │
│            (reads prompts/ and sends MCP calls)            │
└─────────────────────────┬───────────────────────────────────┘
                         │ MCP Protocol
                         ▼
┌─────────────────────────────────────────────────────────────┐
│              cl-mcp-server (MCP Server)                    │
│         Tools: lisp_commit, lisp_evaluate                 │
└─────────────────────────┬───────────────────────────────────┘
                         │
           ┌─────────────┴─────────────┐
           ▼                           ▼
┌─────────────────────┐     ┌─────────────────────────────┐
│    IISCV            │     │       LISA                 │
│ - make-assert       │     │ - Quality rules (ISO 25000) │
│ - Version control   │     │ - Security rules           │
│ - Grafo history    │     │ - NASA JPL rules           │
│ - Audit trail       │     │ - Code analysis            │
└─────────────────────┘     └─────────────────────────────┘
```

## Key Components

### 1. The Bridge (MCP Server)
The MCP server allows an LLM to write directly to system memory. The AI is no longer just a chatbot - it becomes a technical operator with direct access to the Lisp image.

### 2. Security Filter (lisp_commit)
Before any code reaches RAM, it must pass through `lisp_commit`:
- Activates IISCV and LISA
- Audits the code automatically
- Blocks code that violates quality/security rules
- Only accepts code with score ≤ 10

### 3. Persistence (save-lisp-and-die)
The system can save itself as an executable binary, preserving:
- All loaded packages
- Function definitions
- IISCV graph history
- Audit trail

## Using with Kilo

### Setup

```bash
# Clone the repository
git clone https://github.com/gassechen/ioe-dev-test.git
cd ioe-dev-test

# Build the image
chmod 775 build_ioe.sh
./build_ioe.sh
```

### Configuration (kilo.json)

```json
{
  "mcp": {
    "ioe-dev": {
      "type": "local",
      "command": ["./ioe-dev"],
      "enabled": true
    }
  }
}
```

### System Prompt

The `.kilocode/system-prompt-code` file instructs Kilo to:
- Read `prompts/INGENIERIA.md` for engineering directives
- Read `prompts/TAREA_*.md` for specific tasks
- Use `lisp_commit` for all code definitions
- Use `lisp_evaluate` for execution

## Experiment: LLM vs GP Control Benchmark

### What We Did

We used Kilo to automatically generate a controller for a nonlinear oscillator system.

**System Specification:**
- Equation: ẍ + 0.2ẋ + 1.5x + 0.3x³ = u
- Initial condition: x = 1.0, ẋ = 0.0
- Objective: Minimize J = ∫₀¹⁰ (e² + 0.01u²) dt

### The Process

1. **Kilo read the prompts:**
   - `prompts/INGENIERIA.md` - Engineering rules
   - `prompts/TAREA_OSCILADOR.md` - Control problem specification

2. **Kilo created the code using `lisp_commit`:**
   - Package: `IOE-CONTROL-OSCILADOR`
   - Functions: `simulate`, `controller`, `fitness`
   - Each definition was audited by LISA

3. **LISA provided feedback:**
   - Score > 10: Code blocked
   - Score ≤ 10: Code accepted
   - Iterative refinement until passing

4. **Kilo evaluated with `lisp_evaluate`:**
   - Computed fitness J value

### Results

The system demonstrated:
- ✓ Code automatically audited before execution
- ✓ Quality gates enforced (score ≤ 10)
- ✓ Iterative improvement guided by LISA feedback
- ✓ Knowledge persisted in binary image

## Prompt System

### Structure

```
prompts/
├── INGENIERIA.md          # Engineering directives (constant)
└── TAREA_*.md             # Task-specific instructions (variable)
```

### INGENIERIA.md
Contains:
- Environment description
- Tool usage (make-assert, lisp_commit, lisp_evaluate)
- Quality rules table
- Security rules table
- NASA JPL rules
- Protocol to follow

### TAREA_*.md
Contains:
- Specific problem to solve
- Implementation requirements
- Verification steps
- Persistence instructions
- Verification steps to prevent cheating

## Tools Available

| Tool | Purpose |
|------|---------|
| `lisp_commit` | Create definitions with audit (REQUIRED for defun, defvar, etc.) |
| `lisp_evaluate` | Execute expressions without audit (for calculations, tests) |

## IISCV Functions Available to Agent

```lisp
;; Audit & Versioning
(iipv:make-assert form)           ; Audit code
(iipv:get-source-form "PKG:SYM")  ; Get source code
(iipv:show-project-milestones)    ; List commits
(iipv:audit-atomic-history)       ; Audit history

;; Persistence
(iipv:save-development-image "img") ; Save for development
(iipv:save-audit-vault "file")     ; Export audit log
(iipv:dump-source-code)             ; Export source files

;; Image saving (SBCL)
(sb-ext:save-lisp-and-die "ioe-dev" :executable t :toplevel #'cl-mcp-server:run-server)
```

## Why This Matters

### Traditional Development (C++, Python, Java):
1. Write code in file
2. Compile
3. Close program
4. Copy binary
5. Reboot

### With IOE-DEV + Kilo:
1. Tell AI: "Create control logic for this system"
2. AI designs the logic
3. AI passes through quality assurance (LISA)
4. AI injects into live memory
5. System saves itself as binary

**The result: An autonomous executable that evolved from a natural language instruction, while maintaining industrial-grade audit standards.**

## Current Status

- **Infrastructure**: ✓ Complete
- **MCP Integration**: ✓ Working
- **Kilo Integration**: ✓ Working
- **Code Audit**: ✓ Enforced
- **Persistence**: ✓ Functional
- **LLM Benchmark Experiment**: ✓ In Progress

## Links

- [IISCV](https://github.com/gassechen/iiscv)
- [cl-mcp-server](https://github.com/quasi/cl-mcp-server)
- [Kilo](https://kilo.ai)
