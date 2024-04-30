from datetime import datetime
from typing import Optional

from sqlalchemy import select, delete, and_
from db import new_session, TaskOrm
from models.task import STaskAdd, STask, STaskUpdate


class TaskService:
    @classmethod
    async def add_task(cls, data: STaskAdd, user_id: int) -> STask:
        async with new_session() as session:
            task_dict = data.model_dump()

            task = TaskOrm(**task_dict)
            task.owner_id = user_id
            session.add(task)
            await session.flush()
            await session.commit()
            return STask.model_validate(task.__dict__)

    @classmethod
    async def get_task(cls, user_id: int, task_id: int) -> Optional[STask]:
        async with new_session() as session:
            query = select(TaskOrm).where(
                and_(TaskOrm.id == task_id, TaskOrm.owner_id == user_id))
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
            task_schemas = [STask.model_validate(
                task_model) for task_model in task_models]
            return task_schemas

    @classmethod
    async def get_all_overdue_tasks(cls, current_time: datetime, user_id: int) -> list[STask]:
        async with new_session() as session:
            query = select(TaskOrm).where(
                and_(TaskOrm.owner_id == user_id, TaskOrm.deadline < current_time, TaskOrm.deadline is not None,
                     TaskOrm.completed == 0))
            result = await session.execute(query)
            task_models = result.scalars().all()
            task_schemas = [STask.model_validate(
                task_model) for task_model in task_models]
            return task_schemas

    @classmethod
    async def update_task(cls, user_id: int, task_id: int, task_update: STaskUpdate) -> Optional[STask]:
        async with new_session() as session:
            query = select(TaskOrm).where(
                and_(TaskOrm.id == task_id, TaskOrm.owner_id == user_id))
            row = await session.execute(query)
            task = row.first()
            if not task:
                return None
            task_orm = task[0]
            if task_update.title:
                task_orm.title = task_update.title
            if task_update.completed is not None:
                task_orm.completed = task_update.completed
            if task_update.description:
                task_orm.description = task_update.description
            if task_update.deadline:
                task_orm.deadline = task_update.deadline
            await session.commit()
            return STask.model_validate(task_orm.__dict__)

    @classmethod
    async def delete_task(cls, user_id: int, task_id: int) -> bool:
        async with new_session() as session:
            query = delete(TaskOrm).where(
                and_(TaskOrm.id == task_id, TaskOrm.owner_id == user_id))
            await session.execute(query)
            await session.commit()
            return True
