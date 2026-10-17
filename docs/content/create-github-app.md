---
title: "Create a GitHub App for Renovate"
render_macros: true
---
# How to create a GitHub App for Renovate

## Create a dedicated GitHub App
1.  Go to GitHub, Settings, _Developer settings_, [_GitHub Apps_](https://github.com/settings/apps).
2.  Click _New GitHub App_. Give the following values:

    - GitHub App name: (some name, e.g., `My Renovate Bot`)
    - Homepage URL: (some webpage)
    - **Webhook**
        - Active: {{unchecked}} disabled
    - **Permissions**
        - Repository permissions:
            - Administration: Read-only
            - Checks: Read and write
            - Commit statuses: Read and write
            - Contents: Read and write
            - Dependabot alerts: Read-only
            - Issues: Read and write
            - Merge queues: Read and write
            - Metadata: Read-only (required)
            - Pull requests: Read and write
            - Workflows: Read and write
        - Organization permissions:
            - Members: Read-only
    - Where can this GitHub App be installed? Only on this account

3.  Click _Create GitHub App_.
4.  Under _Private Keys_, click _Generate a private key_ and download the `.pem` file.
    Keep it safe, as you will not be able to download it again.
5.  Determine the _Client ID_ (found at the top under _About_).

!!! info "Next Step"
    [Create and configure the Renovate runner repository](./create-renovate-runner-repository.md).


## Install the App
1.  Go to GitHub, Settings, _Developer settings_, [_GitHub Apps_](https://github.com/settings/apps).
2.  Go to the new Apps' page, and go to _Install App_.
3.  Click _Install_. Set:

    - For these repositories: All repositories

    Click _Install_.


## Apply the GitHub App to a repository
See [Enable Renovate PRs](./enable-renovate-prs.md) for instructions on how to apply the GitHub App to a repository.