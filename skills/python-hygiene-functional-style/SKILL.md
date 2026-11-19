---
name: python-hygiene-functional-style
description: "Write Python in pure functional style. Pure functions in a functional core, side effects only in a thin shell at the edges, immutable data, nothing changed in place, expressions over statements, composition and pipelines over loops that accumulate, errors returned as values inside the core, and no recursion Python can't afford. The user's preferences pick a tier of libraries: the standard library alone, then toolz added, then pyrsistent added; the skill says what each tier uses and what it rules out. Use when writing, rewriting or reviewing Python code, scripts or tests, including a skill's bundled scripts, which stay on the standard-library tier."
---

# Pure functional Python

_A program is a functional core of pure functions over immutable data, wrapped in a thin shell that does the input and output. The tier in the preferences says which libraries the core may use._

## The rules, at every tier

- **Pure core, thin shell:** a function in the core takes values and returns a value. Reading files, the clock, the environment or the network, printing, writing and exiting happen only in the shell, usually `main` and a few functions it calls, which pass plain values into the core and act on what comes back.
- **Nothing changes in place:** no `append`, `extend`, `update`, `pop`, `sort()`, `+=` on a collection, or assignment to an attribute or an item. Build a new value instead: a comprehension, `sorted`, `{**a, **b}`, `dataclasses.replace`, or the tier's helpers.
- **Each name is bound once:** within a function, a name isn't reassigned. A value that changes step by step is a pipeline or a `reduce`, not a variable rewritten in a loop.
- **Immutable data:** records are `@dataclass(frozen=True, slots=True)` or `NamedTuple`; sequences are tuples; sets are `frozenset`. A mapping that leaves the function that built it is a `MappingProxyType`, or the tier's persistent map.
- **Expressions over statements:** comprehensions, generator expressions, conditional expressions and `match` with returns in each case, rather than a loop that fills a list or a chain of `if` that sets a variable.
- **Composition:** small functions, combined with `functools.partial`, `operator.itemgetter`, `attrgetter` and `methodcaller`, and the tier's `pipe` and `curry`. Prefer a named function to a long `lambda`.
- **No deep recursion:** Python has no tail-call elimination and stops at about 1,000 frames. Walk a structure of unbounded depth with `reduce`, `itertools.accumulate` or an explicit worklist inside one function, kept pure from outside.
- **Errors as values in the core:** a core function that can fail returns its failure as a value, such as a tuple of problems or a frozen dataclass naming the error, and the caller handles both with `match`. Exceptions are for bugs and for the shell's I/O; the shell turns them into exit codes.
- **Laziness with care:** a generator can be read only once, so the core passes tuples between functions and keeps generators inside the expression that consumes them.
- **Classes hold data, not state:** frozen dataclasses with methods that return new values are fine; a class whose methods change its own attributes isn't.

## Tiers

The preferences name the tier. Each tier adds to the one before; nothing outside the tier is imported in the core.

### Tier 1: the standard library

- `functools`: `reduce`, `partial`, `cache`, `singledispatch`.
- `itertools`: `chain`, `groupby` on sorted input, `accumulate`, `starmap`, `pairwise`, `batched`, `takewhile`, `islice`.
- `operator`: `itemgetter`, `attrgetter`, `methodcaller`, and the arithmetic functions for `reduce`.
- Data: frozen `dataclasses` with `replace`, `typing.NamedTuple`, tuples, `frozenset`, `types.MappingProxyType`.
- Updating a nested dict means rebuilding each level on the path: `{**d, "a": {**d["a"], "b": 1}}`. More than two levels deep is the sign a record type would read better.

### Tier 2: toolz added

- Composition: `toolz.pipe` for a value through steps, `compose_left` for a reusable pipeline, `curry` for functions meant to be partly applied.
- Dicts, returned new: `assoc`, `dissoc`, `assoc_in`, `update_in`, `get_in`, `merge`, `merge_with`, `valmap`, `keymap`, `valfilter`, `keyfilter`.
- Sequences: `groupby` (no sorting needed), `frequencies`, `unique`, `sliding_window`, `partition_all`, `topk`, `concat`, `mapcat`.
- `cytoolz` has the same API and is faster; import whichever the project installs, never both.

### Tier 3: pyrsistent added

- Persistent collections: `pmap`, `pvector`, `pset`. Updates such as `set`, `append` and `remove` return a new collection that shares the unchanged parts, so they copy little.
- `freeze` turns nested dicts, lists and sets from the shell, such as parsed JSON, into persistent structures at the boundary; `thaw` turns them back just before they're written out.
- `PRecord` and `PClass` give typed records with invariants checked on every update, where a frozen dataclass would need `__post_init__`.
- Many updates in one function go through an evolver (`m.evolver()`, then `.persistent()`), which stays local to that function.

## Bundled scripts and checks

- **A skill's bundled scripts stay on tier 1,** whatever the preferences say, so they run on any Python 3 with nothing installed.
- **Tests test the core directly:** pure functions need no mocks, temporary files or patched clocks. Only the shell's tests touch the file system.
- **Reviewing:** flag every in-place change, reassigned name, I/O inside the core, mutable default argument and import beyond the tier.

## Your preferences

!`cat "$(dirname "${CLAUDE_SKILL_DIR}")/python-hygiene-functional-style.preferences.md" "${CLAUDE_PROJECT_DIR}/.agents/skills/python-hygiene-functional-style.preferences.md" 2>/dev/null || true`

If your agent doesn't run the line above, read these files yourself if they
exist: `python-hygiene-functional-style.preferences.md` next to this skill's folder, then
`.agents/skills/python-hygiene-functional-style.preferences.md` in the project. A project's
file overrides the user's, and the user's overrides this skill's defaults.

The keys this skill reads, with its own defaults:

```markdown
- Tier: 1
```

`Tier` is `1` (standard library), `2` (toolz added) or `3` (pyrsistent added).

## When to apply

- Writing or rewriting Python: an application, a script, a hook, a test.
- Reviewing a Python change.
- Writing a skill's bundled Python script, at tier 1.

## Related skills

When one of these applies and it's in your skill listing, load it
without asking. If it isn't in your listing, tell the user which skill is
missing and ask whether to install it from the same collection this skill
came from; don't apply it from memory.

- `coding-agent-skill-references`: the preferences files this skill reads, and where a user's choice goes.
