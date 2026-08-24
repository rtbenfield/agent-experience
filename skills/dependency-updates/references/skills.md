# Skills CLI

Manages installed agent skills. Detected by the presence of `skills-lock.json` in the project root.

## Invocation detection

The CLI may be installed globally or run through a package runner. All invocations run the same code and operate on the same files, so the choice is not critical. Detect once at the start:

1. If `skills-lock.json` coexists with another lockfile, prefer the matching runner: `bun.lock` → `bunx skills`, `pnpm-lock.yaml` → `pnpx skills`, `package-lock.json` → `npx skills`.
2. Otherwise probe in order, using the first that succeeds: `skills --version`, `npx skills --version`, `pnpx skills --version`, `bunx skills --version`.

Record the working invocation and use it for every command below.

## Commands

### Update all skills in the project

```bash
skills update --project
```

Updates all skills declared in `skills-lock.json` to their latest versions. Substitute the detected invocation prefix (e.g., `npx skills update --project`).

## Summarize

**Review the diff.** After the update, inspect changes to skill files. Skill updates may change instructions that affect future runs. Summarize notable changes for the operator.

**Do not modify the contents of managed skills.** Treat them as vendored content. If a verification tool (linter, formatter, tester, custom script) fails on managed skill files, present the failure to the operator and suggest excluding the managed skill directories from that tool's ignore configuration instead of editing the files.

## Notes

- `skills update --project` writes to `skills-lock.json` and the skill directories it manages. It does not touch package manager lockfiles.
