from models.task import Task, TaskCreate, TaskUpdate
from db import fake_tasks_db


def get_tasks():
    return fake_tasks_db


def get_task(task_id: int):
    for task in fake_tasks_db:
        if task.id == task_id:
            return task
    return None


def create_task(task: TaskCreate):
    task_dict = task.dict()
    task_dict["id"] = len(fake_tasks_db) + 1
    new_task = Task(**task_dict)
    fake_tasks_db.append(new_task)
    return new_task


def update_task(task_id: int, task: TaskUpdate):
    for index, existing_task in enumerate(fake_tasks_db):
        if existing_task.id == task_id:
            updated_task = existing_task.copy(update=task.dict())
            fake_tasks_db[index] = updated_task
            return updated_task
    return None


def delete_task(task_id: int):
    for index, task in enumerate(fake_tasks_db):
        if task.id == task_id:
            deleted_task = fake_tasks_db.pop(index)
            return deleted_task
    return None
