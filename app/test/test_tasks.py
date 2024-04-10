from fastapi.testclient import TestClient
from main import app

client = TestClient(app)

# fixme, need in memory test database
# def test_create_task():
#     response = client.post("/tasks", json={"title": "Test Task", "description": "This is a test task"})
#     assert response.status_code == 200
#     assert "id" in response.json()
#     assert response.json()["title"] == "Test Task"
