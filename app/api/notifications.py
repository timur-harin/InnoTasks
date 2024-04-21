import datetime

from fastapi import APIRouter, HTTPException, status
from app.models.notification import NotificationBase
from app.services.task_service import TaskService
from app.services.user_service import UserService

router = APIRouter(
    prefix="/notifications",
    tags=["Notifications"],
)


@router.get("/{token}", name="Get notifications about overdue tasks")
async def get_notifications(token: str) -> list[NotificationBase]:
    split = token.split("_")
    user_id = int(split[0])
    token = split[1]
    check = await UserService.validate_token(user_id, token)
    if not check:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail="No valid token provided")
    tasks = await TaskService.get_all_overdue_tasks(datetime.datetime.now(), user_id)
    notifications = [
        NotificationBase.model_validate({"task_id": task.id}) for task in tasks]
    return notifications
