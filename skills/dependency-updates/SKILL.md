---
name: dependency-updates
description: Use when the operator says "dependency-updates" or "/dependency-updates", asks to update dependencies, upgrade packages, bump deps, or update deps.
metadata:
  author: Tyler Benfield
  version: "2026.8.24"
---

# Dependency Updates

Update project dependencies to their latest versions in a systematic way, producing one PR per dependency or logical group.

## Pre-conditions — halt if unmet

- **Dirty working tree.** The repository must have a clean working tree before starting. Commit or stash changes first.

## Detect environment

Check for these markers in the project root, in priority order. Halt if no marker is found.

| Marker | Manager | Reference |
|---|---|---|
| `bun.lock` | Bun | [bun.md](references/bun.md) |
| `pnpm-lock.yaml` | pnpm | [pnpm.md](references/pnpm.md) |
| `package-lock.json` (without `pnpm-lock.yaml` or `bun.lock`) | npm | [npm.md](references/npm.md) |
| `requirements.txt` or `pyproject.toml` (without Poetry/PDM) | pip | [pip.md](references/pip.md) |
| `go.mod` | Go | [go.md](references/go.md) |
| `Cargo.toml` | Cargo | [cargo.md](references/cargo.md) |
| `skills-lock.json` | Skills CLI | [skills.md](references/skills.md) |

Load only the reference file for the detected manager. `skills-lock.json` may coexist with another marker — in that case, load both references and run the Skills CLI update as its own phase (Phase 3).

## Determine verification commands

Identify the project's verification commands — type checking, linting, and tests. Record these before starting. Use the same commands in every **Verify** step below.

## Procedure

### Phase 1: Safe updates

Batch all updates unlikely to introduce breaking changes into a single pass.

1. **Identify available updates.** Run the manager's outdated command. Record the full list — you'll return to it.
2. **Apply safe updates.** Follow the reference file for the detected manager to update within ranges or apply patch/minor updates. Explicit major upgrades are handled in Phase 2.
3. **Verify.** Run the verification commands determined above. If verification fails:
   - If a single dependency is the cause, revert that dependency and move it to Phase 2.
   - If the cause is unclear, revert all updates and process dependencies individually to isolate.
4. **Deliver.** Commit and open a PR (see [PR conventions](#pr-conventions)).

### Phase 2: Major updates

For each remaining dependency with a major version bump, process individually or as a logical group:

**Grouping rule**: Dependencies that version together should be upgraded in the same PR. Identify co-versioned packages by shared namespace prefix (e.g., `@prisma/*`), shared repository (monorepo), or coordinated release announcements. All others get separate PRs.

For each dependency or group:

1. **Update.** Install the latest version using the package manager.
2. **Identify breaking changes.** Find the dependency's changelog or release notes. Focus on the current version → latest version migration path.
3. **Migrate.** Apply necessary changes to address breaking changes identified in the changelog.
4. **Verify.** Run the verification commands determined above. Fix any issues.
5. **Deliver.** Commit and open a PR (see [PR conventions](#pr-conventions)).

Repeat for each dependency or group as a separate PR. All PRs may be open concurrently.

### Phase 3: Agent skills update

Runs only when `skills-lock.json` is present. Applies to installed agent skills, not package dependencies.

1. **Detect invocation.** Follow [skills.md](references/skills.md) to determine how the Skills CLI is invoked on this machine.
2. **Update.** Run `skills update --project`.
3. **Verify.** Run the verification commands determined above.
4. **Deliver.** Commit and open a PR (see [PR conventions](#pr-conventions)).

### PR conventions

Before committing, check `git log --oneline -10` for the repository's commit message style and PR conventions. Follow those patterns.

## Advice

- **Patch and minor updates** should not cause breaking changes, but may introduce small type differences. Accept small changes; revert and pin the current version if type errors or API changes appear in 10+ files. Move the reverted dependency to Phase 2.
- **Prefer bundling range-resolvable updates** into a single PR in Phase 1. Only split if verification fails and the cause is isolated to a single dependency.

## Forbidden actions

- Do not skip verification after any update step.
- Do not delete and regenerate lockfiles to resolve merge conflicts. Use targeted updates only.
