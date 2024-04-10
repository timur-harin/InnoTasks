from pydantic import BaseModel, EmailStr

class UserBase(BaseModel):
    email: EmailStr

class UserCreate(UserBase):
    password: str

class User(UserCreate):
    id: int

class TokenData(BaseModel):
    email: str
