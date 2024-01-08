# Rundown GitHub Actions installer

``` yaml
jobs:

  build:
    runs-on: ubuntu-latest

    steps:
      - uses: elseano/rundown-actions@v1
      - run: rundown build
```
