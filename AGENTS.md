# python-skills

Agent skills for writing Python, packaged as a Nix flake. Each skill is a directory under `skills/` with a `SKILL.md` and its own sub-flake, built by agent-skill-flake; `source.nix` states the owner its package keys carry.

## Build and test

- `nix develop`: the dev shell, with the project's skills installed into `.agents/skills/` from the `skills-devshell/` sub-flake; run `menu` to list its commands.
- `nix flake check`: fails on any file `nix fmt` would change.
- `nix fmt`: formats every file, nixfmt over `.nix` and prettier over Markdown and YAML.
