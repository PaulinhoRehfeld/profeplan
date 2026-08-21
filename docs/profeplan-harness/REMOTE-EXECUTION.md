# ProfePlan Harness remote execution

The Hostinger VPS runner accepts only jobs dispatched by `PaulinhoRehfeld`.

Issue admission requires all of the following:

1. The Issue was opened by `PaulinhoRehfeld`.
2. Its body begins with `HARNESS JOB`.
3. `PaulinhoRehfeld` applies the `harness:ready` label.

Each admitted job starts from the current `origin/main`, executes in an
isolated Git worktree and branch, and may create a Draft PR. It never merges.

The Harness Web UI remains private on VPS loopback and is not part of this
control plane.
