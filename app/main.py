from fastapi import FastAPI
from api import authentication, tasks, notifications

app = FastAPI()

app.include_router(authentication.router)
app.include_router(tasks.router)
app.include_router(notifications.router)
