---
name: prompt-doc-summary-updates
description: Use when finishing a development task in a repository and you need to check whether the task summary should be reflected in root documentation files such as README.md, CLAUDE.md, or AGENTS.md before presenting or delegating branch-completion options
---

# Prompt Doc Summary Updates

## Overview

Check the current repository root for `README.md`, `CLAUDE.md`, and `AGENTS.md`, then ask whether the completed task should be summarized in those files before the branch-finishing workflow continues.

## Process

1. Determine the current repository root.
2. Check only the repository root for these exact filenames:
   - `README.md`
   - `CLAUDE.md`
   - `AGENTS.md`
3. Split the result into two groups:
   - Existing files
   - Missing files
4. If at least one file exists, ask whether to update the existing file(s) with a concise summary of the completed task.
5. If at least one file is missing, ask whether to create the missing file(s) and add the same summary.
6. If both groups are non-empty, ask about both in the same prompt.
7. Do not edit or create any documentation file until the user explicitly confirms.

## Response Pattern

Use a short status summary first, then ask one concise question.

Example:

```text
I checked the repository root.
Existing documentation files: README.md, AGENTS.md
Missing documentation files: CLAUDE.md

Do you want me to update the existing file(s) with a summary of this task, and also create any missing file(s) with the same summary?
```

If all three files are missing, say so explicitly and ask whether they should be created.

If all three files already exist, say so explicitly and ask whether they should be updated.

## Red Flags

- Do not search outside the repository root.
- Do not silently skip missing files.
- Do not assume documentation should be updated just because code changed.
- Do not combine this prompt with branch merge, push, or discard decisions.

## Integration

Use this immediately before `finishing-a-development-branch` or any wrapper skill delegates to it.
