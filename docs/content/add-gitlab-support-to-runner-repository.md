---
title: "Add GitLab support to Renovate runner repository"
render_macros: false
---
# How to add GitLab support to the Renovate runner repository
After [setting up the Renovate runner repository](./create-renovate-runner-repository.md) on GitHub, we add support for GitLab:

1.  In the repository's settings, under _Secrets and variables_, _Actions_, add the following secrets to _Repository secrets_:

    - `RENOVATE_GITLAB_TOKEN`: the GitLab service account PAT

2.  Create `config.gitlab.js` in the repository:

    ```javascript title="config.gitlab.js"
    module.exports = {
      platform: "gitlab",
      endpoint: "https://gitlab.com/api/v4/",

      // Only repositories that explicitly opt in
      autodiscover: true,
      autodiscoverTopics: ["renovate-managed"],

      // Onboard repositories with the shared preset
      onboarding: true,
      onboardingConfig: {
        extends: ["github>my-org/renovate-config"]
      },

      // Limit MR volume
      prConcurrentLimit: 5,
      prHourlyLimit: 2,

      // Security defaults
      allowScripts: false,
      allowPlugins: false,
      allowedCommands: [],
      allowedUnsafeExecutions: []
    };
    ```

    !!! note ""
        Replace `my-org` by the name of your organization or user.

3.  Add another job to the Renovate workflow in `.github/workflows/renovate.yml`:

    ```json title=".github/workflows/renovate.yml"
    # ...
    jobs:
      renovate-github:
        # ...
      renovate-gitlab:
        name: 'Renovate GitLab'
        runs-on: ubuntu-latest
        timeout-minutes: 55
        steps:
          - name: 'Checkout configuration'
            # yamllint disable rule:line-length
            uses: actions/checkout@v7
            with:
              persist-credentials: false
              
          - name: 'Generate GitHub App token'
            id: app-token
            # yamllint disable rule:line-length
            uses: actions/create-github-app-token@v3
            with:
              client-id: ${{ secrets.RENOVATE_GITHUB_APP_CLIENT_ID }}
              private-key: ${{ secrets.RENOVATE_GITHUB_APP_PRIVATE_KEY }}
              owner: ${{ github.repository_owner }}

          - name: 'Show execution mode'
            run: |
              echo "Log level: ${{ inputs.log_level || 'info' }}"
              echo "Dry run: ${{ inputs.dry_run && 'full' || 'null' }}"

          - name: 'Run Renovate'
            # yamllint disable rule:line-length
            uses: renovatebot/github-action@v46.3.7
            with:
              configurationFile: config.gitlab.js
              token: ${{ secrets.RENOVATE_GITLAB_TOKEN }}
              mount-docker-socket: false
              renovate-version: '44'
            env:
              LOG_LEVEL: ${{ inputs.log_level || 'info' }}
              RENOVATE_DRY_RUN: ${{ inputs.dry_run && 'full' || 'null' }}
              RENOVATE_GITHUB_COM_TOKEN: ${{ steps.app-token.outputs.token }}

    ```

    This workflow additionally does the following:

    - Start the Renovate Docker container.
    - Read `config.gitlab.js`.
    - Check authorized repositories for outdated dependencies.
    - Create or update dependency pull requests.
    - Terminate when finished.

    The 55-minute job timeout help avoid expiration during execution, but if you have many repositories you might need batching across separate jobs.

!!! info "Next Step"
    [Configure and enable Renovate for a specific GitLab repository](./enable-renovate-on-gitlab.md).
