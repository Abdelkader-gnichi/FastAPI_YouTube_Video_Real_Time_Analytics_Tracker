FROM python:3.13.3-slim-bullseye@sha256:f0acec66ba3578f142b7efc6a3e5ce62a5f51639ea430df576f9249c7baf6ef2

RUN pip install uv \
    && uv venv /opt/venv \
    && pip install --upgrade pip
    
ENV PATH="/opt/venv/bin:$PATH"

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


RUN apt-get update && apt-get install -y \
    libpq-dev \
    libjpeg-dev \
    libcairo2 \
    gcc \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /app
    

WORKDIR /app

COPY requirements.txt /tmp/requirements.txt

COPY ./src /app/

RUN uv pip install -r /tmp/requirements.txt

COPY  ./boot/docker-run.sh /opt/run.sh

RUN chmod +x /opt/run.sh

RUN apt-get remove --purge -y \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
    
CMD ["/opt/run.sh"]