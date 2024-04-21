from datetime import datetime
from typing import Optional

from pydantic import BaseModel, ConfigDict


class STaskAdd(BaseModel):
    title: str
    owner_id: int
    completed: bool = False
    description: Optional[str] = None
    deadline: Optional[datetime] = None


class STaskUpdate(BaseModel):
    title: Optional[str] = None
    completed: Optional[bool] = None
    description: Optional[str] = None
    deadline: Optional[datetime] = None


class STask(STaskAdd):
    id: int

    model_config = ConfigDict(from_attributes=True)
