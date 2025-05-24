from api.common.models import BaseModel
from sqlmodel import SQLModel

class YouTubeVideoData(SQLModel, table=False):
    title: str = ""

class YouTubePlayerState(BaseModel, table=False):
    isReady: bool
    video_id: str
    videoData: YouTubeVideoData
    currentTime: float | int = 0.0
    videoStateLabel: str = "CUED"
    videoStateValue: float | int = -10
