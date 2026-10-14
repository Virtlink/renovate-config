---
title: "Auto-merge PRs after CI succeeds"
render_macros: true
---
# How to auto-merge PRs after GitHub CI succeeds
The shared Renovate preset enables squash auto-merge. Protect the default branch and enable GitHub auto-merge so Renovate can request a merge after all required checks succeed.

## Create a modern branch ruleset
Go to the repository _Settings_, _Rules_, _Rulesets_. Click _New ruleset_, _New branch ruleset_. Set:

- Ruleset Name: `Protect main`
- Enforcement status: Active
- Bypass list: (_Add bypass_, _Repository admin_)
    - Repository admin
- Target branches: (_Add target_, _Include default branch_)
    - (Default)
- Rules:
    - Restrict deletions: {{checked}} Yes
    - Require signed commits: {{checked}} Yes
    - Require a pull request before merging: {{checked}} Yes
    - Require status checks to pass: {{checked}} Yes
        - Require branches to be up to date before merging: {{checked}} Yes
        - Required status checks: _Set at least one status check_
    - Block force pushes: {{checked}} Yes

Click _Create_.



## Create a classic branch protection rule
Go to the repository _Settings_, _Branches_. Click _Add classic branch protection rule_ to create a new branch protection rule with:

- Branch name pattern: `main`
- **Protect matching branches**
    - Require a pull request before merging: {{checked}} Yes
        - Require approvals: {{unchecked}} No
        - Dismiss stale pull request approvals when new commits are pushed: {{checked}} Yes
        - Require review from Code Owners: {{unchecked}} No
        - Require approval of the most recent reviewable push: {{unchecked}} No
    - Require status checks to pass before merging: {{checked}} Yes
        - Require branches to be up to date before merging: {{checked}} Yes
        - Status checks that are required: _Set at least one status check_
    - Require conversation resolution before merging: {{unchecked}} No
    - Require signed commits: {{checked}} Yes
    - Require linear history: {{unchecked}} No
    - Lock branch: {{unchecked}} No


## Enable auto-merge
Go to the repository _Settings_, _General_, set:

- Allow auto-merge: {{ yes }} enabled



