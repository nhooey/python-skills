{
  description = "python-skills dev-shell skill set — an isolated sub-flake invoked at RUNTIME by the root devShell, never a root input. The skill sources live only in THIS flake's lock, so the root python-skills stays a leaf with zero skill inputs and transitive consumers never drag the skill mesh in.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    systems.url = "github:nix-systems/default";

    # The builder lib. agent-skill-flake carries zero skill inputs, so it does
    # not drag the skill mesh into this sub-flake's lock — only the skill
    # sources below do.
    agent-skill-flake = {
      url = "github:nhooey/agent-skill-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Skill sources, the same repos `github:nhooey/skillspkgs` aggregates.
    # They follow `nixpkgs` but not `agent-skill-flake`: forcing skillspkgs'
    # `authoring` combination's transitive sources onto a single pinned
    # builder surfaces an ownerless aggregate-key the strict namespace check
    # rejects, so each source keeps its own (compatible) builder.
    # `mkDevshellSkillsFlake` still runs from this flake's
    # `agent-skill-flake.lib`, so the combiner is the pinned rev above.
    coding-agent-skills = {
      url = "github:nhooey/coding-agent-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-skills = {
      url = "github:nhooey/git-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-skills = {
      url = "github:nhooey/nix-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    shell-skills = {
      url = "github:nhooey/shell-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    writing-skills = {
      url = "github:nhooey/writing-skills";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # skillspkgs' curated `authoring` combination, surfaced through its own
    # subdir flake (`mkCombination` keeps a combination re-composable). Its
    # nhooey skill inputs follow the ones above, so it builds from the same
    # revisions.
    skillspkgs-combinations = {
      url = "github:nhooey/skillspkgs?dir=sources/combinations";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        git-skills.follows = "git-skills";
        nix-skills.follows = "nix-skills";
      };
    };
  };

  outputs =
    {
      nixpkgs,
      agent-skill-flake,
      ...
    }@inputs:
    agent-skill-flake.lib.mkDevshellSkillsFlake {
      inherit nixpkgs;
      systems = import inputs.systems;
      name = "python-skills-devshell";
      sources = [
        # Commits, branches and pull requests, and the github-policy-* skills.
        { source = inputs.git-skills; }
        # Safe shell commands: named deletes, PIDs, no machine-wide changes.
        { source = inputs.shell-skills; }
        # The prose of a SKILL.md: headings, lists, tables and labels.
        { source = inputs.writing-skills; }
        # Headless runs in a checkout, a tidy scratchpad, the plan graph, the
        # shape of a turn's responses, and how a skill names other skills and
        # reads its preferences files.
        {
          source = inputs.coding-agent-skills;
          skills = [
            "coding-agent-headless-in-checkout"
            "coding-agent-kanban-turn-responses"
            "coding-agent-plans-as-graph"
            "coding-agent-scratchpad-scripts"
            "coding-agent-skill-references"
          ];
        }
        # Skill authoring: nix-flakes, humanizer, Anthropic's skill-creator
        # and superpowers.
        { source = inputs.skillspkgs-combinations.combinations.authoring; }
      ];
    };
}
