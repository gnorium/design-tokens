# Repository guidance

This directory is its own Git repository. The parent Gnorium workspace is not a repository; run Git commands here and inspect sibling repositories separately.

- Preserve unrelated working changes. When renaming an internal API, update callers in sibling packages rather than leave obsolete aliases.
- Run focused checks for the changed behavior. Do not run full server/browser suites unless requested.
- Keep build caches and `.build` directories. Diagnose build/toolchain errors before rebuilding; do not wipe caches to troubleshoot.
- Batch related changes before building. Deployment requires an explicit user request; a local build or server restart is not deployment.
- If committing authorized work, omit attribution trailers and push normally after the commit; never force-push.

## Color construction

- The current named palette uses APCA and OKLCH; the old WCAG-only named palette is superseded. Use the generators and semantic tokens, not hand-picked hex colors.
- Read the current `design-tokens` README and implementation for the formulas. Neutral fills mirror light/dark contrast; solid labels use `colorOnSolid` (white in light, black in dark).
- Use base borders on control edges and meaningful graphics, subtle borders on frames/cards/tables/dividers and chart grids.
- The current-line band has its own mirrored token; do not substitute the general neutral stripe.

