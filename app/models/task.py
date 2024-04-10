from pydantic import BaseModel

class TaskBase(BaseModel):
    title: str
    description: str = None

class TaskCreate(TaskBase):
    pass

class TaskUpdate(TaskBase):
    pass

class Task(TaskBase):
    id: int
