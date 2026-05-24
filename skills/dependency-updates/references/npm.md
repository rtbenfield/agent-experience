# npm

## Commands

### Outdated

```bash
npm outdated
```

Outputs a table of current → wanted → latest versions.

### Upgrade (range-resolvable)

```bash
npm update
```

Updates all dependencies within their currently declared semver ranges. Does not bump major ranges.

### Install specific version

```bash
npm install <package>@<version>
```

Updates or adds a package at a specific version, rewriting the lock file.

### Install latest of a package

```bash
npm install <package>@latest
```

Resolves to the latest published version regardless of semver range constraints.

### Audit for vulnerabilities

```bash
npm audit
```

Checks dependencies against known vulnerability databases. Run after updates to catch security issues.

## Lockfile conflict resolution

When rebasing or merging a branch with conflicting changes to `package-lock.json`:

1. Accept one side of the conflict: `git checkout --theirs package-lock.json` (or `--ours` depending on context).
2. Run `npm install`. npm will reconcile the lockfile, resolving missing entries without intentionally bumping existing transitive dependencies.

npm is less precise than pnpm at preserving transitive resolution versions. After reconciliation, inspect the diff of `package-lock.json` to confirm only the intended dependency changed. If transitive deps shifted unexpectedly, manually revert those sections and re-run `npm install`.

Do not delete and regenerate `package-lock.json`.

## Notes

- `npm update` only updates within semver ranges declared in `package.json`. To accept a new major, change the range in `package.json` or use `npm install <package>@latest`.
- `npm outdated` exits with code 0 when everything is up to date and non-zero when outdated dependencies exist.