from contextlib import asynccontextmanager
from typing import Union
# from api.db.session import init_db
from fastapi import FastAPI
from api.videos_events.routing import router as yt_videos_events_router
from fastapi.middleware.cors import CORSMiddleware

@asynccontextmanager
async def lifespan(app: FastAPI):
    # before startup
    # init_db()
    yield
    # clean up


app = FastAPI(lifespan=lifespan)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(yt_videos_events_router, prefix='/api/video-events')

@app.get('/')
def greeting():
    return {'message': 'hello world!'}

@app.get('/healthz')
def get_api_health_status():
    return {'status': 'ok'}



