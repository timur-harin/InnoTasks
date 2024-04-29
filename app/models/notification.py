from pydantic import BaseModel


class NotificationBase(BaseModel):
    task_id: int
    message: str = "Task is overdue!"
