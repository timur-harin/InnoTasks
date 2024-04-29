import datetime
import secrets
from typing import Optional

from sqlalchemy import select, and_
from db import new_session, UserOrm
from models.user import UserBase, User, UserChangePassword


def generate_token():
    token = ''.join(
        secrets.choice('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') for _ in range(32))
    return token


class UserService:

    @classmethod
    async def register_user(cls, data: UserBase) -> Optional[User]:
        async with new_session() as session:
            query = select(UserOrm).where(UserOrm.email == data.email)
            row = await session.execute(query)
            if not row.first():
                user_dict = data.model_dump()
                user = UserOrm(**user_dict)
                user.token = generate_token()
                user.last_token_update = datetime.datetime.now()
                session.add(user)
                await session.flush()
                await session.commit()
                return User.model_validate(user.__dict__)
            else:
                return None

    @classmethod
    async def login_user(cls, data: UserBase) -> Optional[User]:
        async with new_session() as session:
            query = select(UserOrm).where(and_(UserOrm.email == data.email, UserOrm.password == data.password))
            row = await session.execute(query)
            user = row.first()
            if not user:
                return None
            else:
                user_orm = user[0]
                user_orm.token = generate_token()
                user_orm.last_token_update = datetime.datetime.now()
                await session.commit()
                return User.model_validate(user_orm.__dict__)

    @classmethod
    async def change_password(cls, data: UserChangePassword) -> Optional[User]:
        async with new_session() as session:
            query = select(UserOrm).where(and_(UserOrm.email == data.email, UserOrm.password == data.password))
            row = await session.execute(query)
            user = row.first()
            if not user:
                return None
            else:
                user_orm = user[0]
                user_orm.token = generate_token()
                user_orm.last_token_update = datetime.datetime.now()
                user_orm.password = data.new_password
                await session.commit()
                return User.model_validate(user_orm.__dict__)

    @classmethod
    async def validate_token(cls, user_id: int, token: str) -> bool:
        async with new_session() as session:
            thirty_minutes_ago = datetime.datetime.now() - datetime.timedelta(minutes=30)
            query = select(UserOrm).where(
                and_(UserOrm.id == user_id, UserOrm.token == token, UserOrm.last_token_update is not None,
                     UserOrm.last_token_update >= thirty_minutes_ago))
            result = await session.execute(query)
            user = result.first()
            if not user:
                return False
            return True
