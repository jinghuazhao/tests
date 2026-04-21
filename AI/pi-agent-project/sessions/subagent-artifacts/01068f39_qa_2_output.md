---

## **QA Report: PASS (with 1 fix applied)**

### **Summary**
The CSV statistics CLI implementation is **functionally correct** and all tests pass.

### **Bug Found & Fixed**

| Issue | Location | Cause | Fix |
|-------|----------|-------|-----|
| `pip install` fails | `pyproject.toml` | References `README.md` that doesn't exist | Created `README.md` |

### **Verification Results**

#### ✅ Core Functionality
```bash
$ python3 -m csvstats data.csv
Column: value
Count:  5
Mean:   30        # ✓ (10+20+30+40+50)/5 = 30
Median: 30        # ✓ middle value of sorted data
```

#### ✅ All Test Cases Passed
| Test Case | Result |
|-----------|--------|
| Basic mean/median | PASS |
| Even count median (10,20,30,40 → 25) | PASS |
| Float values | PASS |
| `--version` flag | PASS |
| Missing file (exit code 1) | PASS |
| Invalid column (exit code 1) | PASS |
| Non-numeric data validation | PASS |
| Empty file handling | PASS |
| KeyboardInterrupt handling | PASS |

#### ✅ Statistical Correctness
- **Mean**: Uses `statistics.mean()` → arithmetic mean ✓
- **Median**: Uses `statistics.median()` → handles both odd/even counts correctly ✓
  - Odd: `[10,20,30,40,50]` → `30`
  - Even: `[10,20,30,40]` → `(20+30)/2 = 25`

#### ✅ Error Handling
- File not found → `CSVError` with clear message
- Missing column → `CSVError` with available columns listed
- Non-numeric data → `ValidationError` with row numbers
- Empty data → `ValidationError`
- Exit codes: 0=success, 1=runtime error, 2=CLI error ✓

### **Minor Note (Non-blocking)**
The return type annotation in `calculate_statistics()` says `Dict[str, float]`, but `count` is returned as `int`. This is a type annotation inconsistency that doesn't affect runtime behavior.

### **Tasks Completed**
- [x] Code runs with `python -m csvstats data.csv`
- [x] Mean and median computed correctly
- [x] Bugs detected and fixed
- [x] CLI entry points verified