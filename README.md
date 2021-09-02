# Cyberduck CLI Github Action

The universal file transfer tool duck which runs in your shell on Linux and OS X or your Windows command line prompt now for Github Actions conveniently in a docker container.

## Inputs

### Mode

```
with:
  mode: 'list|longlist|upload|download|delete'
```

#### List
*Requires URL*

Returns a flat name-list in outputs.log

```
with:
  mode: list
  url: 's3:/'
```

#### Long List
*Requires URL*

Returns a detailed name-list in outputs.log

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

#### Raw
Technically requires nothing, though github action requires setting `url`-parameter. You can refer to that through `$INPUT_URL`.
Use `args` as raw command to `duck`.

```
with:
  mode: raw
  url: ''
  args: '--help'
```

### URL
URL to remote file or directory. Check `docker run ghcr.io/iterate-ch/cyberduck --help` for supported protocols.

### Path
Path to local file or directory, relative to `/github/workspace`.

## Required Environment Variables

### Username
Username to use for authentication against remote.

### Password
Password to use for authentication against remote.

### Command
Refer to `duck --help` / `docker run --rm -it ghcr.io/iterate-ch/cyberduck:latest --help`.
Include Username (`-u`) and Password (`-p`) for authenticated uploads.

## Outputs

### Log
Returns full log (quiet, output only) in a multiline string.

## Example Usage

```
uses: iterate-ch/cyberduck-cli-action@main
id: upload-artifacts
with:
  mode: upload
  url: 's3:/bucket/path'
  path: 'target/Release/*'
```

Using output:
```
run: echo ${{ steps.upload.artifacts.outputs.log }}
```