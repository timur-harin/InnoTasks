import asyncio
from fastapi.testclient import TestClient
from app.main import app
from app.models.user import UserBase, User
from app.services import user_service


# client = TestClient(app)
#
#
# def test_creation_and_authentication():
#     test_user = UserCreate(email="testuser@example.com", password="testpassword")
#     user_service.create_user(test_user)
#
#     response = user_service.authenticate_user(email="testuser@example.com", password="testpassword")
#     assert response.email == test_user.email
#
#
# def test_invalid_login():
#     response = client.post("/token", data={"username": "invaliduser", "password": "invalidpassword"})
#     assert response.status_code == 401
