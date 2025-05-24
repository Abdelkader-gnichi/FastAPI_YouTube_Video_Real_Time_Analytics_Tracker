from .models import YouTubePlayerState, YouTubeVideoData
from fastapi import APIRouter
from datetime import datetime

router = APIRouter()


@router.get('/')
def create_video_event():
    payload = YouTubePlayerState(
        is_ready = True,
        video_data = YouTubeVideoData(title = 'hhhh'),
        current_time=5,
        video_state_label='Cued',
        video_state_value=-11
    )
    print(payload)
    return payload
