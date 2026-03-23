---
title: dchook
layout: HalostatueCa.ProjectLayout
related_tag: dchook
categories: [Go, DevOps, Docker Compose]
description: |
  A webhook listener for updating a Docker Compose configuration when updated.
project_links:
  - Source Code: https://github.com/halostatue/dchook
  - Releases: https://github.com/halostatue/dchook/releases
---

`dchook` is a secure webhook receiver for updating Docker Compose deployments
and an accompanying command-line tool for sending webhooks. It sits between
manual `scp`/`git pull` and full orchestration—perfect for simpler production
deployments needing automated updates from CI/CD.

The **dchook** component is a webhook listener that authenticates webhooks and
triggers Docker Compose updates (via `docker compose pull` and
`docker compose up -d`).

The **dchook-notify** component is a CLI tool for sending authenticated webhook
requests.

## Security Features

`dchook` has a security-forward design with minimal configuration.

- **HMAC signature verification**: Secure constant-time algorithms (SHA-256,
  SHA-384, and SHA-512) are used for payload validation.[^1]

- **Strict rate limits** and **replay protection**: `dchook` applies
  non-configurable rate limits for each of its endpoints and webhook payloads
  cannot be replayed if the envelope timestamp is too old (-300 seconds) or too
  new (+60 seconds) or has been seen in the previous ten minutes.

- **IP banning**: two successive webhook validation failures result in a
  one-hour rejection from the originating IP address, which is extracted using
  standard trusted proxy headers and processes.

- **Strict payload limits**: payloads exceeding 1 MiB are rejected

- **Strict version compatibility**: The `dchook` server and `dchook-notify` must
  be the same major and minor versions, and if they are the same patch version,
  they must be identical commits.

[^1]: The HMAC algorithm selection is the only security configuration option.
    Through `DCHOOK_ALLOWED_ALGORITHMS` the permitted algorithms may be
    restricted from support for all three algorithms to two or only one SHA
    algorithm.

## Listener (`dchook`)

Install the listener either by downloading from [releases][releases], which are
signed with cosign and have SLSA attestations, or use a container image
(`docker pull ghcr.io/halostatue/dchook/dchook-listener:1.2.0`).

The main documentation includes examples on how to deploy `dchook` as a
`systemd` service or in a _separate_ Docker Compose environment.

### Configuration {#listener-configuration}

The listener is configured on startup via command-line flags or environment
variables (flags take precedence).

```bash
# Required
# -s /path/to/secret
DCHOOK_SECRET_FILE=/path/to/secret
# -c /path/to/docker-compose.yml
DCHOOK_COMPOSE_FILE=/path/to/docker-compose.yml

# Optional
# -project myapp
DCHOOK_COMPOSE_PROJECT=myapp
# -b 127.0.0.1
DCHOOK_BIND_ADDRESS=127.0.0.1
# -p 7999
DCHOOK_PORT=7999
# -algorithms sha256,sha384,sha512
DCHOOK_ALLOWED_ALGORITHMS=sha256,sha384,sha512
```

## CLI Tool (`dchook-notify`)

Install the notification tool by downloading from [releases][releases]. There
are examples in the main documentation on calling `dchook-notify` from the
command-line or as part of a GitHub Actions workflow.

### Configuration {#notify-configuration}

The listener is configured on startup via command-line flags or environment
variables (flags take precedence).

### CLI Tool

```bash
# Required
# -u https://webhook.example.com
DCHOOK_URL=https://webhook.example.com
# -s /path/to/secret
DCHOOK_SECRET_FILE=/path/to/secret

# Optional
# -a sha256
DCHOOK_ALGORITHM=sha256
```

[releases]: https://github.com/halostatue/dchook/releases
