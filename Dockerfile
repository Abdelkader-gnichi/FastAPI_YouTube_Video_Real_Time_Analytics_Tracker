FROM python:3.13.3-slim-bullseye AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    libjpeg-dev \
    libcairo2-dev \
    curl \
    && apt-get purge -y --auto-remove gcc \  
    && apt-get clean && rm -rf /var/lib/apt/lists/*

ADD https://astral.sh/uv/install.sh /install.sh
RUN chmod -R 655 /install.sh && /install.sh && rm /install.sh
    
ENV PATH="/root/.local/bin:$PATH"


COPY ./pyproject.toml /opt/pyproject.toml

RUN cd /opt && \
    uv sync

################################### FINAL STAGE ####################################
FROM python:3.13.3-slim-bullseye


ARG APP_USER=appuser
ARG APP_GROUP=appgroup
RUN groupadd -r ${APP_GROUP} && useradd --no-log-init -r -g ${APP_GROUP} ${APP_USER}


RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libjpeg62-turbo \
    libcairo2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
  

COPY ./boot/docker-run.sh /opt/run.sh
RUN chmod +x /opt/run.sh

COPY --from=builder --chown=${APP_USER}:${APP_GROUP} /opt/.venv /opt/.venv

WORKDIR /app

COPY /src .


ENV PATH="/opt/.venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


USER ${APP_USER}


CMD ["/opt/run.sh"]