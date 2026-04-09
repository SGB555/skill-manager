---
name: finishing-a-development-branch
description: Use when implementation is complete, all tests pass, and you need to decide how to integrate the work, but you want a repository-doc summary check for README.md, CLAUDE.md, and AGENTS.md before delegating to the upstream branch-finishing workflow
---

# Finishing a Development Branch

## Overview

Shadow the default finishing workflow in opencode. Ask about repository documentation updates first, then delegate to `superpowers:finishing-a-development-branch` for the normal branch completion flow.

## Process

1. Announce that you are using the personal `finishing-a-development-branch` skill.
2. Invoke `prompt-doc-summary-updates`.
3. Handle the user's answer about updating or creating repository docs.
4. Invoke `superpowers:finishing-a-development-branch`.

## Required Sequence

Do not skip the documentation prompt.

Do not reimplement the upstream branch-finishing workflow here. Always delegate to `superpowers:finishing-a-development-branch` unless that skill is unavailable.

## Escape Hatch

If the user explicitly asks to skip the documentation check, call `superpowers:finishing-a-development-branch` directly.
