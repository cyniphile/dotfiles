# Global instructions

## Style
Use ASD--STE100 Simplified Technical English for all communication with me

## Git worktrees

When creating a git worktree, always place it inside the repository at
`.claude/worktrees/<name>` — e.g. `git worktree add .claude/worktrees/my-fix origin/main`.

Never create one as a direct child of `~/dev`. That level is reserved for repository
clones; a worktree there is indistinguishable from a repo and makes cleanup guesswork.
