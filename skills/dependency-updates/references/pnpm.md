# pnpm

## Commands

### Outdated

```bash
pnpm outdated
```

Outputs a table of current → wanted → latest versions. "Latest" may exceed semver ranges.

### Upgrade (range-resolvable)

```bash
pnpm upgrade
```

Updates all dependencies within their currently declared semver ranges. Does not bump major ranges.

### Install specific version

```bash
pnpm add <package>@<version>
```

Updates or adds a package at a specific version, rewriting the lock file.

### Install latest of a package

```bash
pnpm add <package>@latest
```

Resolves to the latest published version regardless of semver range constraints.

### Audit for vulnerabilities

```bash
pnpm audit
```

Checks dependencies against known vulnerability databases. Run after updates to catch security issues.

## Lockfile conflict resolution

When rebasing or merging a branch with conflicting changes to `pnpm-lock.yaml`:

1. Accept one side of the conflict: `git checkout --theirs pnpm-lock.yaml` (or `--ours` depending on context).
2. Run `pnpm install`. pnpm will reconcile the lockfile — resolving any missing entries from the accepted version without bumping existing transitive dependencies.

Do not delete and regenerate `pnpm-lock.yaml`. That can pull in unintended transitive updates.

## Notes

- `pnpm outdated` separates dependencies by semver change type (patch / minor / major) in its output.
- For workspace projects, `pnpm upgrade --recursive` updates across all workspace packages.
- `pnpm update` is an alias for `pnpm upgrade`. Prefer `upgrade` for clarity.