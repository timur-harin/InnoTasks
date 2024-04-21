from pydantic import BaseModel


class NotificationBase(BaseModel):
    id: int
    task_id: int
    message: str = "Срок задания подошел к концу!"
