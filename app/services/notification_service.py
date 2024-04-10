from models.notification import Notification, NotificationCreate
from db import fake_notifications_db


def send_notification(notification: NotificationCreate):
    notification_dict = notification.dict()
    notification_dict["id"] = len(fake_notifications_db) + 1
    new_notification = Notification(**notification_dict)
    fake_notifications_db.append(new_notification)
    return new_notification
