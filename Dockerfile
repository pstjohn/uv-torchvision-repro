FROM python:3.10

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

WORKDIR /_lock
COPY . /_lock/
RUN uv lock --extra-index-url https://download.pytorch.org/whl/cu124

RUN --mount=type=cache,target=/root/.cache <<EOT
uv sync \
    --frozen \
    --no-install-workspace \
    --package meta
EOT
