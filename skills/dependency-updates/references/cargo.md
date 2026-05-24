# Cargo

## Commands

### Outdated

Use [`cargo-outdated`](https://github.com/rustsec/cargo-outdated):

```bash
cargo outdated
```

Outputs a table of current → compatible → latest versions. "Compatible" is the maximum within semver range; "Latest" is the newest published version.

If `cargo-outdated` is not installed:

```bash
cargo install cargo-outdated
```

### Upgrade (range-resolvable)

```bash
cargo update
```

Updates all dependencies in `Cargo.lock` to the latest versions compatible with the semver ranges in `Cargo.toml`. Does not modify `Cargo.toml`.

### Install specific version

Edit the version requirement in `Cargo.toml`, then:

```bash
cargo update -p <crate>
```

Or use [`cargo-edit`](https://github.com/killercup/cargo-edit):

```bash
cargo add <crate>@<version>
```

### Audit for vulnerabilities

```bash
cargo audit
```

Checks dependencies against the RustSec advisory database. Run after updates to catch known vulnerabilities.

### Verify after updates

```bash
cargo check
cargo test
cargo clippy
```

## Lockfile conflict resolution

When rebasing or merging a branch with conflicting changes to `Cargo.lock`:

1. Accept one side of the conflict: `git checkout --theirs Cargo.lock` (or `--ours` depending on context).
2. Run `cargo update -p <crate>` for only the crate(s) that were changed on the other branch. This resolves their entries without updating unrelated transitive dependencies.

Do not run bare `cargo update` to resolve conflicts — it updates all transitive dependencies to their latest compatible versions, which may unintentionally shift versions.

If targeted `cargo update -p` does not fully resolve the lockfile (e.g., dependency was added rather than version-bumped), run `cargo check`. If that succeeds, the lockfile is valid. If it fails due to missing entries, `cargo update -p <missing-crate>` will add them without touching others.

## Notes

- `Cargo.toml` declares version requirements (ranges); `Cargo.lock` pins exact versions. `cargo update` only updates `Cargo.lock` within those ranges.
- To accept a new major version, update the version requirement in `Cargo.toml` then run `cargo update -p <crate>`.
- `cargo outdated` requires a separate install (`cargo install cargo-outdated`). If unavailable, fall back to `cargo update --dry-run` for a limited view.
- Run `cargo audit` after updates to catch known security vulnerabilities. If vulnerabilities are found, update or pin accordingly before proceeding.