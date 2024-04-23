import uvicorn
from fastapi import FastAPI
from contextlib import asynccontextmanager

from db import create_tables
from api.users import router as user_router
from api.tasks import router as task_router
from api.notifications import router as notifications_router


@asynccontextmanager
async def lifespan(app: FastAPI):
    await create_tables()
    yield


app = FastAPI(lifespan=lifespan)

app.include_router(user_router)
app.include_router(task_router)
app.include_router(notifications_router)

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
