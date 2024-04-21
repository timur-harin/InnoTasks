from fastapi import FastAPI

from contextlib import asynccontextmanager

from app.db import create_tables
from app.api.users import router as user_router
from app.api.tasks import router as task_router
from app.api.notifications import router as notifications_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    await create_tables()
    yield


app = FastAPI(lifespan=lifespan)

app.include_router(user_router)
app.include_router(task_router)
app.include_router(notifications_router)
