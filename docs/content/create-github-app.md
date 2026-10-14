---
title: "Create a GitHub App for automation"
render_macros: true
---
# How to create a GitHub App for automation

## Create a GitHub App
1.  Go to GitHub, Settings, _Developer settings_, [_GitHub Apps_](https://github.com/settings/apps).
2.  Click _New GitHub App_. Give the following values:

    - GitHub App name: `My Bot`
    - Homepage URL: `https://example.com/`
    - **Webhook**
        - Active: {{unchecked}} disabled
    - **Permissions**
        - Repository permissions:
            - Commit statuses: Read and write (for Renovate)
            - Contents: Read and write
            - Issues: Read and write
            - Metadata: Read-only (required)
            - Pull requests: Read and write
            - Workflows: Read and write
    - Where can this GitHub App be installed? Only on this account

3.  Click _Create GitHub App_.
4.  Under _Private Keys_, click _Generate a private key_ and download the `.pem` file.
    Keep it safe, as you will not be able to download it again.
5.  Determine the _App ID_ (found at the top under _About_).

## Apply the GitHub App to a repository
See [Enable Renovate PRs](./enable-renovate-prs.md) for instructions on how to apply the GitHub App to a repository.