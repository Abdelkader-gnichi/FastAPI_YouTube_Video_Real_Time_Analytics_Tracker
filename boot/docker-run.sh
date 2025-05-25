#!/bin/bash

source /opt/.venv/bin/activate

cd /app

RUN_PORT=${PORT:-8000}
RUN_HOST=${HOST:-0.0.0.0}

# Production deployment
gunicorn -k uvicorn.workers.UvicornWorker -b $RUN_HOST:$RUN_PORT main:app
# Developemnt deployment
# uvicorn main:app --host 0.0.0.0 --port 8002  --reload
