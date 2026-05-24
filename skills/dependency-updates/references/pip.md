# Python (pip)

## Commands

### Outdated

```bash
pip list --outdated
```

Outputs a table of current → latest versions for all installed packages. Add `--format=json` for machine-readable output.

### Upgrade (range-resolvable)

pip does not have a built-in "update within ranges" command. For projects using `requirements.txt`:

```bash
pip install --upgrade -r requirements.txt
```

For projects using `pyproject.toml` with pip (no Poetry/PDM):

```bash
pip install --upgrade .
```

Updates dependencies to the latest versions satisfying their version specifiers.

### Install specific version

```bash
pip install <package>==<version>
```

### Install latest of a package

```bash
pip install --upgrade <package>
```

Resolves to the latest published version regardless of version specifier constraints.

### Audit for vulnerabilities

```bash
pip audit
```

Checks dependencies against known vulnerability databases. Requires [`pip-audit`](https://pypi.org/project/pip-audit/):

```bash
pip install pip-audit
pip audit
```

## Lockfile conflict resolution

pip does not natively produce lockfiles. Projects typically use one of:

- **`requirements.txt`** with pinned versions (`==`) — resolve conflicts manually or regenerate:
  ```bash
  pip freeze > requirements.txt
  ```
  This is a full regeneration, so review the diff carefully to ensure only intended changes are included.

- **`requirements.lock`** or similar (via `pip-tools`) — regenerate:
  ```bash
  pip-compile requirements.in
  ```
  This respects the version specifiers in `requirements.in` and produces a deterministic lockfile.

When rebasing or merging:

1. Accept one side of the conflict for pinned requirement files.
2. Re-run `pip-compile` (if using pip-tools) or `pip install -r requirements.txt` to reconcile.
3. Inspect the diff to confirm only the intended dependency changed.

## Notes

- Python does not have a single canonical dependency format. Detect the project type:
  - `requirements.txt` — pip
  - `requirements.in` + `requirements.txt` — pip-tools
  - `Pipfile` + `Pipfile.lock` — pipenv (covered separately)
  - `pyproject.toml` with `[tool.poetry]` — Poetry (covered separately)
  - `pyproject.toml` with `[tool.pdm]` — PDM (not covered)
- This reference covers **pip** and **pip-tools** only. Poetry and pipenv have different workflows.
- `pip list --outdated` shows all installed packages including transitive dependencies. Cross-reference with `requirements.txt` or `pyproject.toml` to focus on direct dependencies.
- For pip-tools projects, always edit `requirements.in` (the source of truth) and run `pip-compile` to regenerate `requirements.txt`. Never edit `requirements.txt` directly.
- When upgrading a major version, check the package's changelog on PyPI or its GitHub releases. Python packages do not always follow semver strictly.