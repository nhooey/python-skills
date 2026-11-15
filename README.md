# python-skills

Agent skills for writing Python, packaged as a Nix flake.

Each skill is a self-contained directory under [`skills/`](skills/) with a
`SKILL.md` that an agent loads on demand. Skills are built by
[`agent-skill-flake`](https://github.com/nhooey/agent-skill-flake).

## Skills

| Skill                                                                                | What it does                                                                                                                                                                   |
| ------------------------------------------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| [`python-hygiene-functional-style`](skills/python-hygiene-functional-style/SKILL.md) | Pure functional Python: a pure core over immutable data, effects in a thin shell, at a library tier set in the preferences: the standard library, then toolz, then pyrsistent. |

## Install

```bash
# Preview what installing every skill would change, without writing anything
nix run github:nhooey/python-skills#preview

# Install all skills into the agent's skill directory
nix run github:nhooey/python-skills#install
```

Package outputs:

- `agent-skills-nhooey-python-all` — the aggregate of every skill (also `default`)
- `agent-skill-nhooey-python-hygiene-functional-style`

## Development

```bash
nix develop      # enter the dev shell; run `menu` to list commands
nix fmt          # nixfmt over *.nix, prettier over *.md / *.yaml
nix flake check  # runs the treefmt check (fails on any unformatted file)
```
