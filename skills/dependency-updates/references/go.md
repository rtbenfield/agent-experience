# Go

## Commands

### Outdated

Go has no built-in outdated command. List available updates:

```bash
go list -u -m -json all
```

Returns JSON for each module with `Update` field when a newer version exists. Alternatively, use [`go-mod-outdated`](https://github.com/psampaz/go-mod-outdated):

```bash
go list -u -m -json all | go-mod-outdated -update -direct
```

### Upgrade (range-resolvable)

Go modules have no lockfile-enforced ranges — any version allowed by `go.mod` `require` directives is fair game. The SKILL.md Phase 1 step uses `go get -u ./...` to bring all dependencies up to their latest minor/patch versions. Major version bumps are handled in Phase 2.

Patch-level only:

```bash
go get -u=patch ./...
```

Minor and patch updates (used for Phase 1 safe updates):

```bash
go get -u ./...
```

Updates all dependencies to their latest minor or patch versions.

### Install specific version

```bash
go get <module>@<version>
```

Sets the module to the specified version in `go.mod`.

### Tidy after updates

```bash
go mod tidy
```

Removes unused dependencies and adds missing ones. Run after any `go get` operation.

### Verify downloads

```bash
go mod verify
```

Verifies downloaded modules match their checksums.

### Audit for vulnerabilities

```bash
govulncheck ./...
```

Checks dependencies against the Go vulnerability database. Requires [`govulncheck`](https://pkg.go.dev/golang.org/x/vuln/cmd/govulncheck) to be installed. Run after updates to catch known security issues.

## Lockfile conflict resolution

Go has two files to consider:

- **`go.mod`**: Small and declarative. Resolve conflicts manually — accept both sets of changes since they are additive (new `require` directives). Lines with conflicting versions for the same module need a decision on which version to keep.
- **`go.sum`**: Pure derivative of `go.mod`. Delete the file and regenerate:

```bash
rm go.sum
go mod tidy
```

This is safe because `go.sum` contains only checksums — no version decisions, no risk of transitive updates. `go mod tidy` will reconstruct it exactly from `go.mod`.

## Notes

- Go modules use semantic import versioning: major versions require a different import path (e.g., `/v2` suffix).
- `go get -u ./...` updates to the latest minor/patch. For major version bumps, the import path changes — treat this as a migration.
- Always run `go mod tidy` after dependency changes. Unused entries in `go.mod` will cause lint failures in many setups.
- When upgrading a major version, search for the module's `README.md` or `CHANGELOG.md` in its repository. The import path change is the primary source of breakage.