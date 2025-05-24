from api.common.models import BaseModel
from sqlmodel import SQLModel

class YouTubeVideoData(SQLModel, table=False):
    title: str = ""

class YouTubePlayerState(BaseModel):
    is_ready: bool
    video_data: YouTubeVideoData
    current_time: int = 0
    video_state_label: str = "CUED"
    video_state_value: int = -10
    