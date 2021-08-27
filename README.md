# Cyberduck Cli Github Action

The universal file transfer tool duck which runs in your shell on Linux and OS X or your Windows command line prompt now for Github Actions conveniently in a docker container.

## Inputs

### Command
Refer to `duck --help` / `docker run --rm -it ghcr.io/iterate-ch/cyberduck:latest --help`.
Include Username (`-u`) and Password (`-p`) for authenticated uploads.

## Outputs
None.

## Example Usage

```
uses: iterate-ch/cyberduck-cli-action@main
with:
  command: '--upload  s3:/bucket/path'
```