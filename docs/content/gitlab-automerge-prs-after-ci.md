---
title: "Auto-merge PRs after CI succeeds"
render_macros: true
---
# How to auto-merge PRs after GitLab CI succeeds
The shared Renovate preset enables squash auto-merge. Protect the default branch and enable GitLab auto-merge so Renovate can request a merge after all required checks succeed.


1.  Go to the repository _Settings_, _Repository_. Open _Branch rules_. Click _View details_ at the `main` branch. Set:

    - Allowed to merge: Developers and Maintainers, Maintainers
    - Allowed to push and merge: Maintainers

2.  Go to _Settings_, _Merge requests_. Set:

    - **Merge checks**
        - Pipelines must succeed: {{checked}} checked

    Click _Save changes_.


