from models.user import User, UserCreate
from db import fake_users_db


def get_user_by_email(email: str):
    for user in fake_users_db:
        if user.email == email:
            return user
    return None


def authenticate_user(email: str, password: str):
    user = get_user_by_email(email)
    if not user:
        return False
    if not password == user.password:
        return False
    return user


def create_user(user: UserCreate):
    user_dict = user.dict()
    user_dict["id"] = len(fake_users_db) + 1
    fake_users_db.append(User(**user_dict))
    return user


async def create_user_async(user_data: UserCreate):
    create_user(user_data)
