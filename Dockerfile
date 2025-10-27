# Multi-stage build: Elixir + Bun → Static files → Caddy server
FROM hexpm/elixir:1.19.0-erlang-27.2-alpine-3.21.2 AS builder

WORKDIR /app

# Install build dependencies
RUN apk add --no-cache git build-base curl unzip

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash
ENV PATH="/root/.bun/bin:${PATH}"

# Install Elixir dependencies
COPY mix.exs mix.lock ./
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod

# Install Bun dependencies
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

# Copy source and build
COPY . .
RUN MIX_ENV=prod mix build

# Serve with hardened Caddy (HTTP only, Caddy reverse proxy handles HTTPS)
FROM dhi.io/caddy:2

COPY --from=builder /app/_site /usr/share/caddy
COPY Caddyfile /etc/caddy/Caddyfile

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://localhost/ || exit 1
