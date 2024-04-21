from fastapi import APIRouter, Depends, HTTPException, status
from app.models.task import *
from app.services.task_service import TaskService


router = APIRouter()


@router.get("/tasks", response_model=list[STask])
async def read_tasks():
    return get_tasks()

@router.post("/tasks", response_model=Task)
async def create_task(task: TaskCreate):
    return create_task(task)


@router.put("/tasks/{task_id}", response_model=Task)
async def update_task(task_id: int, task: TaskUpdate):
    updated_task = update_task(task_id, task)
    if updated_task is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Task not found")
    return updated_task


@router.delete("/tasks/{task_id}", response_model=Task)
async def delete_task(task_id: int):
    deleted_task = delete_task(task_id)
    if deleted_task is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Task not found")
    return deleted_task
