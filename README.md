# Secret Mask GitHub Action

[![Action test workflow](https://github.com/matteo-magni/secret-mask-action/actions/workflows/test.yml/badge.svg)](https://github.com/matteo-magni/secret-mask-action/actions/workflows/test.yml)

By default, a GitHub Actions secret gets hidden in workflows outputs by replacing it with `***`.
However, this applies only in its entirety but not to parts of it.

This GitHub Action extracts all the values in a JSON or YAML secret and masks them.

## Usage

```yaml
- uses: matteo-magni/secret-mask-action@main
  with:
    secret: ${{ secrets.FAKE_SECRET_JSON }}

```
