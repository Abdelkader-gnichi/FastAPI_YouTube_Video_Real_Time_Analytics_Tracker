# === Stage 1: Builder ===
FROM python:3.13.3-slim-bullseye AS builder

RUN apt-get update && apt-get install -y \
    gcc \
    libpq-dev \
    libjpeg-dev \
    libcairo2 \
    && pip install uv \
    && uv venv /opt/venv \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ENV PATH="/opt/venv/bin:$PATH"

# Install build-time dependencies
COPY requirements.txt /tmp/requirements.txt
RUN uv pip install -r /tmp/requirements.txt

# Copy application code
COPY ./src /app
COPY ./boot/docker-run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

# === Stage 2: Final runtime image ===
FROM python:3.13.3-slim-bullseye

# Only copy the virtualenv and code from builder
COPY --from=builder /opt/venv /opt/venv
COPY --from=builder /app /app
COPY --from=builder /opt/run.sh /opt/run.sh

ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# Optional: Install any runtime libs only if really needed (e.g., libpq-dev is for psycopg2)
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libjpeg-dev \
    libcairo2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["/opt/run.sh"]