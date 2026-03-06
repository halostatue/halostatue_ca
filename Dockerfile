# syntax=docker/dockerfile:1

FROM hexpm/elixir:1.19.5-erlang-28.3.2-debian-trixie-20260202-slim AS builder

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    build-essential \
    curl \
    unzip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install hex and rebar
RUN mix local.hex --force && mix local.rebar --force

# Install Elixir dependencies
COPY mix.exs mix.lock ./
RUN mix do deps.get + deps.compile

# Install Bun dependencies
COPY package.json bun.lockb ./
RUN mix do bun.install + bun install

# Copy application code and build
COPY . .
RUN MIX_ENV=prod mix build

FROM dhi.io/caddy:2

COPY --from=builder /app/_site /usr/share/caddy
COPY --from=builder /app/redirects.caddy /etc/caddy/redirects.caddy
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
