from datetime import datetime
from typing import Optional

from sqlalchemy import select, and_
from app.db import new_session, TaskOrm
from app.models.task import STaskAdd, STask, STaskUpdate


class TaskService:
    @classmethod
    async def add_task(cls, data: STaskAdd) -> int:
        async with new_session() as session:
            task_dict = data.model_dump()

            task = TaskOrm(**task_dict)
            session.add(task)
            await session.flush()
            await session.commit()
            return task.id

    @classmethod
    async def get_task(cls, user_id: int, task_id: int) -> Optional[STask]:
        async with new_session() as session:
            query = select(TaskOrm).where(and_(TaskOrm.id == task_id, TaskOrm.owner_id == user_id))
            result = await session.execute(query)
            task_model = result.scalar()
            if task_model:
                return STask.model_validate(task_model)
            return None

    @classmethod
    async def get_all_tasks(cls, user_id: int) -> list[STask]:
        async with new_session() as session:
            query = select(TaskOrm).where(TaskOrm.owner_id == user_id)
            result = await session.execute(query)
            task_models = result.scalars().all()
            task_schemas = [STask.model_validate(task_model) for task_model in task_models]
            return task_schemas

    @classmethod
    async def get_all_overdue_tasks(cls, current_time: datetime, user_id: int) -> list[STask]:
        async with new_session() as session:
            query = select(TaskOrm).where(
                and_(TaskOrm.owner_id == user_id, TaskOrm.deadline < current_time, TaskOrm.deadline is not None))
            result = await session.execute(query)
            task_models = result.scalars().all()
            task_schemas = [STask.model_validate(task_model) for task_model in task_models]
            return task_schemas

    @classmethod
    async def update_task(cls, user_id: int, task_id: int, task_update: STaskUpdate) -> Optional[STask]:
        async with new_session() as session:
            task = session.query(TaskOrm).filter(and_(TaskOrm.id == task_id, TaskOrm.owner_id == user_id)).first()
            if not task:
                return None
            if task_update.title:
                task.title = task_update.title
            if task_update.completed:
                task.completed = task_update.completed
            if task_update.description:
                task.description = task_update.description
            if task_update.deadline:
                task.deadline = task_update.deadline
            session.commit()
            return STask.model_validate(task)

    @classmethod
    async def delete_task(cls, task_id: int) -> bool:
        async with new_session() as session:
            task = session.query(TaskOrm).filter(TaskOrm.id == task_id).first()
            if not task:
                return False
            else:
                session.delete(task)
                session.commit()
                return True
