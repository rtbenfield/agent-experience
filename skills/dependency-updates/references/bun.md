# Bun

## Commands

### Outdated

```bash
bun outdated
```

Outputs a table of current → latest versions for all dependencies.

### Upgrade (range-resolvable)

Bun does not have a direct "update within ranges" command. Use:

```bash
bun update
```

Updates all dependencies to their latest versions that satisfy the semver ranges in `package.json`. Does not bump major ranges.

### Install specific version

```bash
bun add <package>@<version>
```

Updates or adds a package at a specific version, rewriting the lock file.

### Install latest of a package

```bash
bun add <package>@latest
```

Resolves to the latest published version regardless of semver range constraints.

### Audit for vulnerabilities

```bash
bun audit
```

Checks dependencies against known vulnerability databases. Requires Bun 1.2+. For older versions, use `npx npm audit` as a fallback.

## Lockfile conflict resolution

When rebasing or merging a branch with conflicting changes to `bun.lock`:

1. Accept one side of the conflict: `git checkout --theirs bun.lock` (or `--ours` depending on context).
2. Run `bun install`. Bun will reconcile the lockfile — resolving any missing entries from the accepted version without bumping existing transitive dependencies.

Do not delete and regenerate `bun.lock`. That can pull in unintended transitive updates.

## Notes

- `bun update` updates within semver ranges declared in `package.json`. To accept a new major, change the range in `package.json` or use `bun add <package>@latest`.
- Bun uses `bun.lock` (text-based lockfile) instead of `package-lock.json` or `pnpm-lock.yaml`.
- If a project has `package-lock.json` alongside `bun.lock`, prefer `bun.lock` — it is the active lockfile for Bun.
- `bun outdated` is available in Bun 1.2+. For older versions, fall back to `npx npm-check-updates` or manually checking `package.json` against registry versions.