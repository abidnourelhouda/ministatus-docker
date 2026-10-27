import unittest
from app import app

class TestApp(unittest.TestCase):
def setUp(self):
self.client = app.test_client()
def test_health(self):
rep = self.client.get("/health")
self.assertEqual(rep.status_code, 200)
self.assertEqual(rep.get_json(), {"status": "ok"})
def test_version_presente(self):
rep = self.client.get("/version")
self.assertIn("version", rep.get_json())
def test_hello(self):
rep = self.client.get("/hello/Sara")
self.assertEqual(rep.get_json()["message"], "Bonjour Sara")