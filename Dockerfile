FROM python:3.13.3-slim-bullseye AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libpq-dev \
    libjpeg-dev \
    libcairo2-dev \
    && pip install uv \
    && uv venv /opt/venv \
    && apt-get purge -y --auto-remove gcc \  
    && apt-get clean && rm -rf /var/lib/apt/lists/*
    

ENV PATH="/opt/venv/bin:$PATH"


COPY requirements.txt /tmp/requirements.txt
RUN uv pip install -r /tmp/requirements.txt

COPY ./src /app
COPY ./boot/docker-run.sh /opt/run.sh
RUN chmod +x /opt/run.sh


FROM python:3.13.3-slim-bullseye


ARG APP_USER=appuser
ARG APP_GROUP=appgroup
RUN groupadd -r ${APP_GROUP} && useradd --no-log-init -r -g ${APP_GROUP} ${APP_USER}


RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libjpeg62-turbo \
    libcairo2 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


COPY --from=builder --chown=${APP_USER}:${APP_GROUP} /opt/venv /opt/venv
COPY --from=builder --chown=${APP_USER}:${APP_GROUP} /app /app
COPY --from=builder --chown=${APP_USER}:${APP_GROUP} /opt/run.sh /opt/run.sh


ENV PATH="/opt/venv/bin:$PATH"
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


WORKDIR /app

USER ${APP_USER}


CMD ["/opt/run.sh"]