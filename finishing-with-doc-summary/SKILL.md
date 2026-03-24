---
name: finishing-with-doc-summary
description: Use when implementation is complete and you want the normal branch-finishing workflow, but with an extra repository-doc summary check for README.md, CLAUDE.md, and AGENTS.md before the standard completion options are presented
---

# Finishing With Doc Summary

## Overview

Wrap the normal finishing flow with one extra documentation checkpoint. Ask about `README.md`, `CLAUDE.md`, and `AGENTS.md` first, then delegate to `finishing-a-development-branch`.

## Process

1. Announce that you are using `finishing-with-doc-summary`.
2. Invoke `prompt-doc-summary-updates`.
3. Handle the user's answer about updating or creating repository docs.
4. Invoke `finishing-a-development-branch` for the normal verify-or-merge/PR/keep/discard flow.

## Required Sequence

Do not skip the documentation prompt.

Do not inline a custom branch-finishing flow unless the underlying `finishing-a-development-branch` skill is unavailable.

## Integration

- Uses `prompt-doc-summary-updates`
- Delegates branch completion to `finishing-a-development-branch`
