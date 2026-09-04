# Cyberduck CLI GitHub Action

The universal file transfer tool [`duck`](https://duck.sh/) which runs in your shell on Linux and OS X or your Windows command line prompt now for GitHub Actions conveniently in a Docker container.

[![Test](https://github.com/iterate-ch/cyberduck-cli-action/actions/workflows/test.yml/badge.svg)](https://github.com/iterate-ch/cyberduck-cli-action/actions/workflows/test.yml)

## Usage

```yaml
- uses: iterate-ch/cyberduck-cli-action@main
  id: transfer
  env:
    USERNAME: ${{ secrets.S3_ACCESS_KEY }}
    PASSWORD: ${{ secrets.S3_SECRET_KEY }}
  with:
    mode: upload
    url: 's3:/bucket/path/'
    path: 'target/Release/*'
```

This is a [Docker container action](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-docker-container-action).
It builds from the [`ghcr.io/iterate-ch/cyberduck`](https://github.com/iterate-ch/cyberduck/pkgs/container/cyberduck)
image and therefore only runs on Linux runners (`runs-on: ubuntu-latest`). `duck` is
invoked with `-q` (quiet, output only) and `-y` (assume yes for all prompts, such as
overwrite confirmations).

## Inputs

| Name   | Required             | Description                                                                                                                                                    |
|--------|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `mode` | Yes                 | Operation to run. One of `list`, `longlist`, `upload`, `download`, `delete`, `purge`, `raw`.                                                                       |
| `url`  | Yes (except `raw`)  | URL to the remote file or directory. Run `duck --help` or `docker run ghcr.io/iterate-ch/cyberduck --help` for the list of supported protocols and URL schemes.    |
| `path` | Depends on `mode`   | Path to the local file or directory, relative to `/github/workspace` (the checked out repository). Glob patterns such as `bin/Release/*` are supported.            |
| `args` | No                  | Additional raw arguments appended to the `duck` invocation, for example `--verbose --debug` or `--anonymous`. Required when `mode: raw`.                           |

### Mode

```yaml
with:
  mode: 'list|longlist|upload|download|delete|purge|raw'
```

#### List

*Requires `url`*

Returns a flat name-list in `jobs.<job_id>.outputs.log`.

```yaml
with:
  mode: list
  url: 's3:/bucket/'
```

#### Long List

*Requires `url`*

Returns a detailed name-list (permissions, size, modification date) in `jobs.<job_id>.outputs.log`.

```yaml
with:
  mode: longlist
  url: 's3:/bucket/'
```

#### Upload

*Requires `url` and `path`*

Uploads `path` (relative to the workspace) to `url` recursively.

```yaml
with:
  mode: upload
  url: 's3:/bucket/path/'
  path: 'bin/Release/*'
```

#### Download

*Requires `url`. `path` is optional*

Downloads the element specified at `url` to `path` (relative to the workspace) recursively.
When `path` is omitted the download is saved to the current working directory.

```yaml
with:
  mode: download
  url: 's3:/bucket/artifacts/'
  path: 'artifacts/'
```

#### Delete

*Requires `url`*

Deletes the element specified at `url`.

```yaml
with:
  mode: delete
  url: 's3:/bucket/prefix/object'
```

#### Purge

*Requires `url`*

Purges the CDN configuration for the container specified at `url`.

```yaml
with:
  mode: purge
  url: 's3:/bucket'
```

#### Raw

*Requires `args`*

Uses `args` verbatim as the command line for `duck`. `url` and `path` are ignored.

```yaml
with:
  mode: raw
  args: '--help'
```

## Supported Environment Variables

The following [environment variable names](https://docs.github.com/en/enterprise-cloud@latest/actions/writing-workflows/workflow-syntax-for-github-actions#jobsjob_idstepsenv)
are read from the job or step `env` and forwarded to the Cyberduck CLI. Pass credentials
as [encrypted secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions),
never as plain text.

| Variable   | Maps to      | Description                                                                    |
|------------|--------------|-------------------------------------------------------------------------------|
| `USERNAME` | `--username` | Username to use for authentication with the server.                            |
| `PASSWORD` | `--password` | Password to use for authentication with the server.                            |
| `IDENTITY` | `--identity` | Path to the private key file for public key authentication with the server.    |

When none of these are set (for example for anonymous access), pass `args: '--anonymous'`.

## Outputs

### `log`

Full CLI output (quiet, output only) as a multiline string, accessible as
`steps.<step_id>.outputs.log` and, when mapped, as `jobs.<job_id>.outputs.log`.
The same output is also streamed to the workflow log as the step runs.

The step exit code is the exit code of `duck`, so a failed transfer fails the step.

## Example Usage

* Upload the contents of a directory to an S3 bucket, passing
  [secrets](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)
  for authorization:

  ```yaml
  - uses: iterate-ch/cyberduck-cli-action@main
    id: upload-artifacts
    env:
      USERNAME: ${{ secrets.S3_ACCESS_KEY }}
      PASSWORD: ${{ secrets.S3_SECRET_KEY }}
    with:
      mode: upload
      url: 's3:/bucket/path/'
      path: 'target/Release/*'
  ```

* List a public bucket anonymously and use the output in a later step:

  ```yaml
  - uses: iterate-ch/cyberduck-cli-action@main
    id: list
    with:
      mode: list
      url: 's3:/profiles.cyberduck.io/'
      args: '--anonymous'
  - run: echo "${{ steps.list.outputs.log }}"
  ```

* Expose the log as a job output:

  ```yaml
  jobs:
    deploy:
      runs-on: ubuntu-latest
      outputs:
        log: ${{ steps.upload-artifacts.outputs.log }}
      steps:
        - uses: actions/checkout@v4
        - uses: iterate-ch/cyberduck-cli-action@main
          id: upload-artifacts
          env:
            USERNAME: ${{ secrets.S3_ACCESS_KEY }}
            PASSWORD: ${{ secrets.S3_SECRET_KEY }}
          with:
            mode: upload
            url: 's3:/bucket/path/'
            path: 'target/Release/*'
  ```
