# syntax=docker/dockerfile:1

FROM python:3.8-slim AS builder

WORKDIR /build

RUN apt-get update && apt-get install -y \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt .

# Mount the pip cache directory. 
# We remove '--no-cache-dir' so pip writes to the mounted cache.
RUN --mount=type=cache,target=/root/.cache/pip \
    pip install -r requirements.txt

FROM python:3.8-slim

WORKDIR /server

COPY --from=builder /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"

COPY server.py .

COPY ./model/results/prod/model ./model/results/prod/model

EXPOSE 8000

CMD ["fastapi", "run", "server.py", "--port", "8000"]
