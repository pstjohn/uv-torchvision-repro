# uv-torchvision-repro
small repro of uv lock resulting in unsatisfiable environment

```bash

$ docker build -t uv-test .

[+] Building 9.9s (12/12) FINISHED                                                                                               docker:default
 => [internal] load build definition from Dockerfile                                                                                       0.0s
 => => transferring dockerfile: 346B                                                                                                       0.0s
 => [internal] load metadata for ghcr.io/astral-sh/uv:latest                                                                               1.1s
 => [internal] load metadata for docker.io/library/python:3.10                                                                             0.9s
 => [internal] load .dockerignore                                                                                                          0.0s
 => => transferring context: 2B                                                                                                            0.0s
 => FROM ghcr.io/astral-sh/uv:latest@sha256:9ee5e7036ad360efc54dfe1ff868bdd6867323232e3c6e7fd4dc92eeb588d076                               0.0s
 => => resolve ghcr.io/astral-sh/uv:latest@sha256:9ee5e7036ad360efc54dfe1ff868bdd6867323232e3c6e7fd4dc92eeb588d076                         0.0s
 => [internal] load build context                                                                                                          0.0s
 => => transferring context: 32.78kB                                                                                                       0.0s
 => [stage-0 1/6] FROM docker.io/library/python:3.10@sha256:9c0e621579faf384d982986f2e0ba86bf09619076842cd0fbd2f24a3bf09f0bc               0.1s
 => => resolve docker.io/library/python:3.10@sha256:9c0e621579faf384d982986f2e0ba86bf09619076842cd0fbd2f24a3bf09f0bc                       0.0s
 => CACHED [stage-0 2/6] COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv                                                     0.0s
 => CACHED [stage-0 3/6] WORKDIR /_lock                                                                                                    0.0s
 => [stage-0 4/6] COPY . /_lock/                                                                                                           0.1s
 => [stage-0 5/6] RUN uv lock --extra-index-url https://download.pytorch.org/whl/cu124                                                     8.3s
 => ERROR [stage-0 6/6] RUN --mount=type=cache,target=/root/.cache <<EOT (uv sync ...)                                                     0.3s
------
 > [stage-0 6/6] RUN --mount=type=cache,target=/root/.cache <<EOT (uv sync ...):
0.195 Using Python 3.10.14 interpreter at: /usr/local/bin/python3
0.195 Creating virtualenv at: .venv
0.197 error: distribution torchvision==0.15.0 @ registry+https://download.pytorch.org/whl/cu124 can't be installed because it doesn't have a source distribution or wheel for the current platform
```


As an alternative, this dockerfile

```dockerfile
FROM python:3.10

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

RUN <<EOT
pip install \
--extra-index-url https://download.pytorch.org/whl/cu124 \
torch \
torchvision
EOT
```

installs these packages:
* https://download.pytorch.org/whl/cu124/torch-2.4.1%2Bcu124-cp310-cp310-linux_x86_64.whl
* https://download.pytorch.org/whl/cu124/torchvision-0.19.1%2Bcu124-cp310-cp310-linux_x86_64.whl
