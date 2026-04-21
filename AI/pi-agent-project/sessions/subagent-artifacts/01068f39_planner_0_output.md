Now I have a clear picture. Here's the implementation plan:

---

## **Plan: CSV Statistics CLI Package**

### **Current State**
- `data.csv`: Single-column CSV with header "value" containing numeric data
- No existing Python package structure

---

### **1. Numbered Implementation Steps**

| Step | Action | Details |
|------|--------|---------|
| **1** | **Create Package Structure** | Create `csvstats/` package directory with `__init__.py` |
| **2** | **Module: CSV Reader** | Create `csvstats/reader.py` with safe CSV parsing using `csv.DictReader` + validation |
| **3** | **Module: Statistics Engine** | Create `csvstats/stats.py` with mean and median calculations using `statistics` module |
| **4** | **Module: CLI Interface** | Create `csvstats/cli.py` using `argparse` for argument parsing |
| **5** | **Module: Error Handling** | Create `csvstats/exceptions.py` for custom exceptions (CSVError, StatsError, etc.) |
| **6** | **Entry Point** | Create `csvstats/__main__.py` + update `pyproject.toml` with console script |
| **7** | **Project Metadata** | Create `pyproject.toml` with package config, dependencies, and CLI entry |
| **8** | **Validation** | Test with `python -m csvstats data.csv` |

---

### **2. Required Files**

```
pi-agent-project/
├── pyproject.toml              # Package metadata, deps, CLI entry point
├── data.csv                    # Input data (exists)
└── csvstats/                   # Main package
    ├── __init__.py             # Package init (version export)
    ├── __main__.py             # Allows: python -m csvstats
    ├── cli.py                  # Argument parsing & main entry
    ├── reader.py               # Safe CSV parsing
    ├── stats.py                # Mean/median calculations
    └── exceptions.py           # Custom exception classes
```

---

### **3. Dependency Notes**

| Dependency | Purpose | Risk Level |
|------------|---------|------------|
| `python >= 3.8` | `statistics.median()` availability | **Low** |
| `csv` (stdlib) | Safe CSV parsing | **Low** |
| `argparse` (stdlib) | CLI interface | **Low** |
| `pathlib` (stdlib) | Path handling | **Low** |
| `statistics` (stdlib) | Mean/median calc | **Low** |
| `typing` (stdlib) | Type hints | **Low** |

**No external dependencies required** — pure stdlib implementation.

---

### **4. Risk Analysis & Mitigations**

| Risk Category | Risk | Mitigation Strategy |
|-------------|------|---------------------|
| **Parsing** | Malformed CSV (quotes, escapes) | Use `csv.DictReader` — handles RFC 4180 correctly; wrap in try/except for `csv.Error` |
| **Parsing** | Missing "value" column | Validate header exists before processing; raise descriptive error |
| **Parsing** | Empty file | Check file size / catch `StopIteration` on empty iterator |
| **IO** | File not found | Use `pathlib.Path` + explicit `exists()` check; raise `FileNotFoundError` with custom message |
| **IO** | Permission denied | Catch `PermissionError`; map to user-friendly error exit |
| **IO** | Non-utf8 encoding | Open with `encoding='utf-8'` + `errors='replace'` or try/except with fallback |
| **CLI** | Invalid arguments | `argparse` validation; custom `--help`; exit codes (0=success, 1=error, 2=bad args) |
| **Stats** | Non-numeric values | Validate with `float()` conversion; collect errors per-row; report line numbers |
| **Stats** | Empty dataset (no valid rows) | Check count before computing; raise `StatisticsError` handled gracefully |
| **Stats** | Floating point precision | Use `statistics.mean()` (handles precision); document behavior |

---

### **5. Design Decisions**

| Decision | Rationale |
|----------|-----------|
| `__main__.py` | Allows both `python -m csvstats` and console script entry |
| Custom exceptions | Clean separation between library and CLI error handling |
| `statistics` module | Median correctly handles even/odd counts; mean uses stable algo |
| `DictReader` | Column access by name (not index) — resilient to column reordering |

---

### **6. Exit Codes**

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Runtime error (IO, parsing, stats) |
| `2` | CLI usage error (argparse exits with this) |

---

**Ready to implement?** Confirm and I'll execute the plan step-by-step.