# Skills

Skills are focused packages of instructions, reference docs, and scripts that extend what an agent can do. They live in `skills/` and are installed into an agent's skill directory (e.g., `~/.agents/skills/`) via `npx skills add`.

Each skill follows this structure:

```
skill-name/
├── SKILL.md           # Main instructions (required)
├── REFERENCE.md       # Detailed docs (optional)
├── assets/
│   └── EXAMPLES.md    # Usage examples (optional)
└── scripts/           # Utility scripts (optional)
```

`SKILL.md` starts with a YAML frontmatter block that provides the skill's name and description — the description is the only thing the agent sees when deciding whether to load the skill, so it should include specific trigger phrases ("Use when...").
