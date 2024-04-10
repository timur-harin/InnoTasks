from fastapi import APIRouter, Depends, HTTPException, status
from models.task import Task, TaskCreate, TaskUpdate
from services.task_service import get_tasks, get_task, create_task, update_task, delete_task


router = APIRouter()


@router.get("/tasks", response_model=list[Task])
async def read_tasks():
    return get_tasks()


@router.get("/tasks/{task_id}", response_model=Task)
async def read_task(task_id: int):
    task = get_task(task_id)
    if task is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Task not found")
    return task


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
