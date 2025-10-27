# syntax=docker/dockerfile:1

# Multi-stage build: Elixir + Bun → Static files → Caddy server
FROM hexpm/elixir:1.19.5-erlang-28.3.2-debian-trixie-20260202-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    curl \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Elixir dependencies
COPY . .
RUN <<SETUP
mix local.hex --force
mix local.rebar --force
mix do deps.get + deps.compile + bun.install + bun install
SETUP

RUN MIX_ENV=prod mix build

# Serve with hardened Caddy (HTTP only, Caddy reverse proxy handles HTTPS)
FROM dhi.io/caddy:2

COPY --from=builder /app/_site /usr/share/caddy
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
