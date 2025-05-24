from .models import YouTubePlayerState
from fastapi import APIRouter
from datetime import datetime

router = APIRouter()


@router.post('/')
def create_video_event(payload: YouTubePlayerState):
    data = payload.model_dump()
    print(data)
    return data
