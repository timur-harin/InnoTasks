from typing import List
from models.user import User
from models.task import Task
from models.notification import Notification


# Fake in-memory databases
fake_users_db: List[User] = []
fake_tasks_db: List[Task] = []
fake_notifications_db: List[Notification] = []
