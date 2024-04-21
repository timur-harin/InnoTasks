from typing import Annotated

from fastapi import APIRouter, Depends, HTTPException, status
from app.models.user import User, UserBase, UserChangePassword
from app.services.user_service import UserService

router = APIRouter(
    prefix="/users",
    tags=["Users"],
)


@router.post("/auth", name="Resister user")
async def auth_user(form_data: Annotated[UserBase, Depends()]) -> User:
    user = await UserService.register_user(form_data)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="User with such email already exists"
        )
    return user


@router.post("/login", name="Login user")
async def auth_user(form_data: Annotated[UserBase, Depends()]) -> User:
    user = await UserService.login_user(form_data)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email or password is incorrect"
        )
    return user


@router.post("/change_password", name="Change password")
async def auth_user(form_data: Annotated[UserChangePassword, Depends()]) -> User:
    user = await UserService.change_password(form_data)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Email or password is incorrect"
        )
    return user
