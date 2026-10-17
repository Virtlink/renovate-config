---
title: "Create a GitLab service account for Renovate"
render_macros: true
---
# How to create a GitLab service account for Renovate

1.  Go to GitLab, to a group, _Settings_, _Service accounts_.

    !!! note ""
        The group doesn't need to contain your repositories. A service account created in a top-level group can be invited to projects outside that group, including projects in your personal namespace.

2.  Click _Add service account_. Give the following values:

    - Name: (some name, e.g., `My Renovate Bot`)
    - Username: (lowercase username, e.g., `my-renovate-bot`)
    - Email: (blank)

3.  Click the kebab button next to the new service account, _Manage access tokens_.
4.  Click _Add new token_. Set:

    - Token name: Renovate
    - Expiration date: (some future date)
    - **Select scopes**
        - api

    Click _Generate token_.
5.  Copy and save the token. It is needed in GitHub.


## Invite the service account to your groups and personal repositories
1.  In a repository, go to _Manage_, _Members_. Click _Invite members_.
2.  Add the new bot through its username. Set:

    - Role: Developer

    Click _Invite_.



!!! info "Next Step"
    [Create and configure the Renovate runner repository](./create-renovate-runner-repository.md).
