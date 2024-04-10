from fastapi import APIRouter, Depends, HTTPException, status
from models.notification import Notification, NotificationCreate
from services.notification_service import send_notification

router = APIRouter()

@router.post("/notifications", response_model=Notification)
async def create_notification(notification: NotificationCreate):
    return send_notification(notification)
