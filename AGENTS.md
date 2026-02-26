# AGENTS

## Project Specific Rules

- Treat [.github/workflows/Tests.yml](./.github/workflows/Tests.yml) as generated output. When inputs change (for example `Package.swift`, plugin behavior, or ActionBuilderCore versions), regenerate with `swift run ActionBuilderTool .` instead of manual edits.
- Keep changes to this plugin repository focused and minimal.
- For project overview and usage expectations, review [README.md](./README.md).

Relevant local guidance:

- [Swift](./Extras/Documentation/Guidelines/Swift.md)
- [GitHub](./Extras/Documentation/Guidelines/GitHub.md)

## Standard Rules

- Prefer red/green TDD when practical; otherwise run the closest relevant validation checks and report gaps.
- Write good code: correct behavior, explicit error handling, tests for changed behavior where feasible, and updated docs when behavior/workflows change.
- Apply core engineering principles: KISS, YAGNI, DRY, explicit contracts/invariants, dependency injection, composition over inheritance, command-query separation, and idempotent side effects where appropriate.
- Keep changes small and coherent: understand request boundaries, inspect first, apply minimal changes, validate, and report residual risk.
- Prioritize correctness, clarity, and maintainability. Keep interfaces explicit, avoid hidden coupling, and do not add dependencies without clear need.
- Use trusted sources for uncertain technical claims; prioritize official docs/specs and first-party repositories.
- Add concise intent-focused documentation comments for types and members where this improves maintainability.
- Never expose secrets or perform destructive actions without explicit approval.

Detailed guidance for agents and humans:

- [Principles](./Extras/Documentation/Guidelines/Principles.md)
- [Testing](./Extras/Documentation/Guidelines/Testing.md)
- [Trusted Sources](./Extras/Documentation/Guidelines/Trusted%20Sources.md)
- [Good Code](./Extras/Documentation/Guidelines/Good%20Code.md)
- [Swift](./Extras/Documentation/Guidelines/Swift.md)
- [GitHub](./Extras/Documentation/Guidelines/GitHub.md)

---

To refresh this file, use the refresh-agents skill.
