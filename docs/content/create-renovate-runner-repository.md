---
title: "Configure Renovate runner repository"
render_macros: false
---
# How to create and configure the Renovate runner repository
After [creating a GitHub app](./create-github-app.md) for Renovate, we can setup a repository with the configuration and Renovate runner:

1.  Create a new GitHub repository named `renovate-runner`.
2.  In the repository's settings, under _Secrets and variables_, _Actions_, add the following secrets to _Repository secrets_:

    - `RENOVATE_GITHUB_APP_CLIENT_ID`: the GitHub App Client ID
    - `RENOVATE_GITHUB_APP_PRIVATE_KEY`: the entire contents of the `.pem` file (the GitHub App's private key)

    !!! note ""
        The private key is a multi-line string. Make sure to copy the entire contents of the `.pem` file. For example:

        ```
        -----BEGIN RSA PRIVATE KEY-----
        MIIEpgIBAAKCAQEAm9KB2dFRW9iRaRpdaUCWwPxRzlI3hmZxGWX60ump49NuJ4XM
        ...
        RR5z3JpJfVU4pfu8rOeEURBgLuUM4JMho2qU769I8VVlDTjRpRaaITp1
        -----END RSA PRIVATE KEY-----
        ```

3.  Create `config.github.js` in the repository:

    ```javascript title="config.github.js"
    module.exports = {
      platform: "github",
      

      // Only repositories that explicitly opt in
      autodiscover: true,
      autodiscoverTopics: ["renovate-managed"],

      // Onboard repositories with the shared preset
      onboarding: true,
      onboardingConfig: {
        extends: ["github>my-org/renovate-config"]
      },

      // Limit PR volume
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

4.  Create the Renovate workflow in `.github/workflows/renovate.yml` that uses the official [Renovate GitHub Action](https://github.com/renovatebot/github-action?utm_source=chatgpt.com):

    ```json title=".github/workflows/renovate.yml"
    ---
    name: 'Renovate'

    on:  # yamllint disable-line rule:truthy
      schedule:
        # Run every 8 hours at :17 past
        - cron: "17 */8 * * *"
      workflow_dispatch: # Allow manual triggering
        inputs:
          dry_run:
            type: boolean
            required: false
            default: false
            description: 'Run without creating PRs'
          log_level:
            type: string
            required: false
            default: 'info'
            description: 'The log level of Renovate'

    permissions:
      contents: read

    concurrency:
      group: renovate
      cancel-in-progress: false

    jobs:
      renovate-github:
        name: 'Renovate GitHub'
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
              configurationFile: config.github.js
              token: ${{ steps.app-token.outputs.token }}
              mount-docker-socket: false
              renovate-version: '44'
            env:
              LOG_LEVEL: ${{ inputs.log_level || 'info' }}
              RENOVATE_DRY_RUN: ${{ inputs.dry_run && 'full' || 'null' }}

    ```

    This workflow does the following:

    - Execute every _n_ hours, or manually.
    - Generate a short-lived GitHub App installation token.
    - Start the Renovate Docker container.
    - Read `config.github.js`.
    - Check authorized repositories for outdated dependencies.
    - Create or update dependency pull requests.
    - Terminate when finished.

    The 55-minute job timeout help avoid expiration during execution, but if you have many repositories you might need batching across separate jobs.

!!! info "Next Step"
    [Configure and enable Renovate for a specific GitHub repository](./enable-renovate-on-github.md).
