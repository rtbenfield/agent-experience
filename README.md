# Agent Experience

Giving agents the constraints they need to act with agency.

## Agents with agency

> **agency** ⸱ _noun_  
> the ability to take action or to choose what action to take

Agents have deep knowledge of syntax, patterns, and best practices — and a remarkable ability to ignore all of it. Left to their own devices, they produce code that works in isolation but falls apart at the seams: inconsistent conventions, missed edge cases, and solutions that solve the wrong problem.

I have high expectations of my (human) teammates. Not that they understand every element of syntax, every best practice, or complex algorithms, but that they have _agency_. They independently research, evaluate, and make decisions on how to proceed. When necessary, they ask for help, guidance, and team feedback, but they don't need confirmation to take action. I expect the same from my agents.

When a new hire joins the team, they need time to build up enough confidence to execute with agency. Documentation, tooling, and decision frameworks accelerate this process. The same is true for agents. Rules, documentation, and guardrails don't restrict agency — they create it. A human without a style guide writes inconsistent code. An agent without rules writes inconsistent code faster.

My goal is to give my agents enough rules, guardrails, and decision frameworks to act with agency.

## Agency in practice

Once agents have the tools to act with agency, they can be given **outcome-focused prompts** rather than procedural ones.

Implementation-focused:
> Add a "dark mode" toggle to the settings page. Use the Switch component from ui/ and follow the pattern Dashboard uses for toggle controls.
>
> Create a useTheme hook — model it on useNetworkStatus with useSyncExternalStore. Persist the preference to localStorage and dispatch a custom event so other components can react.
>
> Add dark overrides to tokens.css using a [data-theme="dark"] selector on the same custom properties we already define. Wire it up in App.tsx by setting data-theme on the root. Follow the AuthProvider wrapping pattern.
>
> Write unit tests for the hook following the useNetworkStatus test pattern.

Outcome-focused:
> Add a dark mode toggle to settings. Should persist across sessions and apply globally.

The implementation specifics of the outcome-focused prompt may not be exactly the same, but the behavior and code quality should be just as good _or better_. With this level of agency, an agent can find gaps, edge cases, and opportunities that an implementation-focused prompt would be too rigid to allow.

## Workflow

For small tasks with high-agency agents, outcome-focused prompts can often produce a high-quality result with just an initial prompt. For larger projects, we want to implement a software development lifecycle that enables the agent to gather a specification, plan, and execute consistently. This is where agent skills come into my workflow.

- `/project-spec` is given an outcome-focused prompt to research and gather a specification. I review the specification to ensure it covers the requirements I care most about.
- `/project-plan` is given the specification and will generate an implementation plan. It includes phases, tasks, and specific details about what will change. I review the plan to ensure it aligns with my expectations and the sequencing is sound.
- `/project-execute` is given the plan and will execute the implementation. The prompt can reference specific phases or complete the entire plan in one run. The agent will verify its own work, create incremental commits, and track its progress in the plan. Any surprises or deviation will be noted in the plan or, if it would deviate from the plan, surfaced to the operator.

There are also supplementary skills that help the agent with execution and perform other tasks in the software lifecycle.

- `/code-review` reviews code changes against a target (uncommitted changes or a branch diff), producing concise, labeled feedback. It evaluates correctness, clarity, complexity, contract, performance, security, idiomatic style, and verifiability — but only raises areas where the change introduces or worsens issues.
- `/dependency-updates` updates project dependencies systematically. Safe (patch/minor) updates are batched into a single PR; major updates are processed individually or as logical groups (e.g., co-versioned packages), each with its own PR and migration notes.
- `/pr-description` generates a PR description from the git diff between the current branch and the default branch. It produces context and reasoning, not a verbatim change list — organized by component with a "Why" section covering key technical decisions.
- `/pr-response` processes unresolved review comments on an open PR. It assesses each thread as valid/in-scope, valid/out-of-scope, or not valid, implements in-scope feedback, replies to every comment, and resolves threads. It pushes back on feedback that doesn't serve the PR rather than adopting changes reflexively.

## Rules

Rules are instructions injected into the agent's system prompt. They define how the agent should behave — conversation style, code preferences, verification strategy, and more.

### Global rules

[`rules/global.md`](rules/global.md) is loaded in every session via your agent's configuration (e.g., `~/.config/opencode/AGENTS.md`). It covers broad concepts like conversation style, decision making, and code verification. It serves as a baseline for all agent interaction even when a project-specific ruleset is not available.

The global rules remain unopinionated about tech stack and domain concepts. They apply to every project with any language, framework, or tooling choice.

## Skills

The [skills CLI](https://skills.sh/) will walk you through adding these skills to your preferred agents in either the global or project scope.

```sh
npx skills add rtbenfield/agent-experience
```

## Scripts

### install-gitleaks.sh

[`scripts/install-gitleaks.sh`](scripts/install-gitleaks.sh) installs [gitleaks](https://github.com/gitleaks/gitleaks) and configures it as a global git pre-commit hook that runs `gitleaks protect --staged` before every commit.

This prevents the agent (or you) from committing secrets — API keys, tokens, credentials, or any values that match secret-detection patterns. It catches both real secrets and values that merely _look_ like secrets, which is intentional: false positives from a pre-commit hook are preferable to leaked credentials, and they're easy to allowlist via `.gitleaksignore` or inline `gitleaks:allow` comments when the value is known to be safe.

Run to install or update to the latest version:

```sh
./scripts/install-gitleaks.sh
```
