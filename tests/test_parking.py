import unittest
from app import parking

class TestParkingLogic(unittest.TestCase):

    def test_generate_ticket(self):
        ticket_id = parking.generate_ticket("ABC123", "42")
        self.assertIn(ticket_id, parking.tickets)
        self.assertEqual(parking.tickets[ticket_id]["plate"], "ABC123")

    def test_close_ticket(self):
        ticket_id = parking.generate_ticket("XYZ789", "99")
        result = parking.close_ticket(ticket_id)
        self.assertEqual(result["plate"], "XYZ789")
        self.assertIn("total_cost", result)

if __name__ == '__main__':
    unittest.main()
