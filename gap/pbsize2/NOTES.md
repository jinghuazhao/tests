```r
usethis::use_testthat(edition = 3)
```

This sets up the standard testing infrastructure, normally including:
- tests/testthat.R
- tests/testthat/
- Config/testthat/edition: 3 in DESCRIPTION

```bash
git diff -- R/pbsize2.R ChangeLog
R -q -e 'devtools::test()'
```

```
> devtools::test()
ℹ Testing gap
gap version 1.15.3
✔ | F W  S  OK | Context
✔ |          4 | pbsize2

══ Results ═══════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════════
[ FAIL 0 | WARN 0 | SKIP 0 | PASS 4 ]
>
```

Alternatively,

```r
devtools::test(filter = "pbsize2")
```
