import datetime
import secrets
from typing import Optional

from sqlalchemy import select, and_
from app.db import new_session, UserOrm
from app.models.user import UserBase, User


def generate_token():
    token = ''.join(
        secrets.choice('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') for _ in range(32))
    return token


class UserService:

    @classmethod
    async def auth_user(cls, data: UserBase) -> Optional[User]:
        async with new_session() as session:
            query = select(UserOrm).where(UserOrm.email == data.email).first()
            if not query:
                user_dict = data.model_dump()
                user = UserOrm(**user_dict)
                user.token = generate_token()
                user.last_token_update = datetime.datetime.now()
                session.add()
                await session.flush()
                await session.commit()
                return User.model_validate(user)
            else:
                return None

    @classmethod
    async def login_user(cls, data: UserBase) -> Optional[User]:
        async with new_session() as session:
            user = await session.query(UserOrm).filter(
                and_(UserOrm.email == data.email, UserOrm.password == data.password)).first()
            if not user:
                return None
            else:
                user.token = generate_token()
                user.last_token_update = datetime.datetime.now()
                await session.commit()
                return User.model_validate(user)

    @classmethod
    async def change_password(cls, data: UserBase, new_password: str) -> Optional[User]:
        async with new_session() as session:
            user = await session.query(UserOrm).filter(
                and_(UserOrm.email == data.email, UserOrm.password == data.password)).first()
            if not user:
                return None
            else:
                user.token = generate_token()
                user.last_token_update = datetime.datetime.now()
                user.password = new_password
                await session.commit()
                return User.model_validate(user)

    @classmethod
    async def change_password(cls, data: UserBase, new_password: str) -> Optional[User]:
        async with new_session() as session:
            user = await session.query(UserOrm).filter(
                and_(UserOrm.email == data.email, UserOrm.password == data.password)).first()
            if not user:
                return None
            else:
                user.token = generate_token()
                user.last_token_update = datetime.datetime.now()
                user.password = new_password
                await session.commit()
                return User.model_validate(user)

    @classmethod
    async def validate_token(cls, user_id: int, token: str) -> bool:
        async with new_session() as session:
            thirty_minutes_ago = datetime.datetime.now() - datetime.timedelta(minutes=30)
            query = select(UserOrm).where(
                and_(UserOrm.id == user_id, UserOrm.token == token, UserOrm.last_token_update is not None,
                     UserOrm.last_token_update >= thirty_minutes_ago))
            result = await session.execute(query)
            task_model = result.scalar()
            if not task_model:
                return False
            return True
