from datetime import datetime
from typing import Optional

from pydantic import BaseModel


class UserBase(BaseModel):
    email: str
    password: str


class User(UserBase):
    id: int
    token: str
    last_token_update: Optional[datetime] = None
