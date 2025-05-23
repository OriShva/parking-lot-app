import unittest
from app.main import app

class TestAPI(unittest.TestCase):
    def setUp(self):
        self.client = app.test_client()

    def test_entry_and_exit(self):
        # Test /entry
        res = self.client.post("/entry?plate=ABC123&parkingLot=42")
        self.assertEqual(res.status_code, 200)
        ticket_id = res.get_json()["ticketId"]

        # Test /exit
        res = self.client.post(f"/exit?ticketId={ticket_id}")
        self.assertEqual(res.status_code, 200)
        self.assertIn("total_cost", res.get_json())

if __name__ == '__main__':
    unittest.main()
