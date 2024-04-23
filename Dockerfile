# Dockerfile

FROM python:3.11.1-slim

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

COPY . .

RUN pip install poetry
RUN poetry install


CMD ["poetry", "run", "python", "app/main.py"]
