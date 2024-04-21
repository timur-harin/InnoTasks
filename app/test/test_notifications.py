from fastapi.testclient import TestClient
from app.main import app

# client = TestClient(app)
#
#
# def test_create_notification():
#     response = client.post("/notifications", json={"message": "Test Notification"})
#     assert response.status_code == 200
#     assert "id" in response.json()
#     assert response.json()["message"] == "Test Notification"