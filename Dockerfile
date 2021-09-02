FROM ghcr.io/iterate-ch/cyberduck:latest
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
