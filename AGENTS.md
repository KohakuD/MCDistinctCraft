# AGENTS.md

These instructions apply to the entire DistinctCraft repository.

## Repository boundaries

- Treat DistinctCraft as an independent Git and implementation scope.
- Other Minecraft and Kohaku repositories may be read as references but must not be modified as part of this project.
- Never combine files from different repositories in one commit.

## Codex model routing

- Prefer GPT-5.3-Codex-Spark for clearly bounded implementation, documentation, tests, builds, small bugs, and small refactors.
- Use a stronger Codex model for architecture, new large systems, cross-project analysis, difficult bugs, and extensive refactors.
- If a Spark task becomes unexpectedly complex, stop and recommend switching to a stronger model.
- Model choice does not expand task scope or repository permissions.

## Development

- Read README.md, docs/Development.md, and the active docs/Roadmap.md section before code changes.
- Preserve unrelated local changes.
- Run `.\gradlew.bat build` after code changes.
- Keep `en_us`, `de_de`, and `nl_nl` resources aligned.
- Do not commit or push unless explicitly requested.
