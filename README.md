# Cyberduck CLI Github Action

The universal file transfer tool duck which runs in your shell on Linux and OS X or your Windows command line prompt now for Github Actions conveniently in a docker container.

## Inputs

### Mode

```
with:
  mode: 'list|longlist|upload|download|delete|purge|raw'
```

#### List
*Requires URL*

Returns a flat name-list in `jobs.<job_id>.outputs.log`.

```
with:
  mode: list
  url: 's3:/'
```

#### Long List
*Requires URL*

Returns a detailed name-list in `jobs.<job_id>.outputs.log`.

```
with:
  mode: longlist
  url: 's3:/'
```

#### Upload
*Requires URL, Path*

Uploads Path (relative to workspace) to URL, add `--recurse` in `args`

```
with:
  mode: upload
  url: 's3:/'
  path: 'bin/Release/*'
  args: '--recurse'
```

#### Download
*Requires URL*

Downloads element specified at `URL` to path relative to workspace.

```
with:
  mode: download
  url: 's3:/'
  path: 'artifacts/'
  args: '--recurse'
```

#### Delete
*Requires URL*

Deletes element specified at `URL`.

```
with:
  mode: delete
  url: 's3:/bucket/prefix/object'
```

#### Purge
*Requires Purge*

Purges CDN configuration.

```
with:
  mode: purge
  url: 's3:/bucket'
```

#### Raw
Use `args` as raw command to `duck`.

```
with:
  mode: raw
  args: '--help'
```

### URL
URL to remote file or directory. Check `duck --help`/`docker run ghcr.io/iterate-ch/cyberduck --help` for supported protocols.

### Path
Path to local file or directory, relative to `/github/workspace`.

## Required Environment Variables

### Username
Username to use for authentication against remote.

### Password
Password to use for authentication against remote.

## Outputs

### Log
Returns full log (quiet, output only) in a multiline string.

## Example Usage

```
uses: iterate-ch/cyberduck-cli-action@main
id: upload-artifacts
env:
  USERNAME=${{secrets.S3_ACCESS_KEY}}
  PASSWORD=${{secrets.S3_SECRET_KEY}}
with:
  mode: upload
  url: 's3:/bucket/path'
  path: 'target/Release/*'
```

Using output:
```
run: echo ${{ steps.upload.artifacts.outputs.log }}
```
