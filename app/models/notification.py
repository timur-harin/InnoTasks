from pydantic import BaseModel

class NotificationBase(BaseModel):
    message: str

class NotificationCreate(NotificationBase):
    pass

class Notification(NotificationBase):
    id: int
