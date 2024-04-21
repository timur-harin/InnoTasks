from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from app.models.task import *
from app.services.task_service import TaskService
from app.services.user_service import UserService

router = APIRouter(
    prefix="/tasks",
    tags=["Tasks"],
)


@router.post("/{token}", name="Add new task")
async def create_task(token: str, form_data: Annotated[STaskAdd, Depends()]) -> STask:
    split = token.split("_")
    user_id = int(split[0])
    token = split[1]
    check = await UserService.validate_token(user_id, token)
    if not check:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="No valid token provided")
    return await TaskService.add_task(form_data, user_id)


@router.delete("/{task_id}/{token}", name="Deletes task")
async def delete_task(task_id: int, token: str) -> bool:
    split = token.split("_")
    user_id = int(split[0])
    token = split[1]
    check = await UserService.validate_token(user_id, token)
    if not check:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="No valid token provided")
    return await TaskService.delete_task(user_id, task_id)


@router.get("/{task_id}/{token}", name="Get task by id")
async def get_task(task_id: int, token: str) -> STask:
    split = token.split("_")
    user_id = int(split[0])
    token = split[1]
    check = await UserService.validate_token(user_id, token)
    if not check:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="No valid token provided")
    return await TaskService.get_task(user_id, task_id)


@router.get("/{token}", name="Get all tasks of user")
async def get_all_tasks(token: str) -> list[STask]:
    split = token.split("_")
    user_id = int(split[0])
    token = split[1]
    check = await UserService.validate_token(user_id, token)
    if not check:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="No valid token provided")
    return await TaskService.get_all_tasks(user_id)


@router.put("/{task_id}/{token}", name="Updates task")
async def update_task(task_id: int, token: str, update: Annotated[STaskUpdate, Depends()]) -> STask:
    split = token.split("_")
    user_id = int(split[0])
    token = split[1]
    check = await UserService.validate_token(user_id, token)
    if not check:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="No valid token provided")
    return await TaskService.update_task(user_id, task_id, update)
