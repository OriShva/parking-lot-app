import uuid
from datetime import datetime

# In-memory storage for active tickets
tickets = {}

# Rate: $10/hour => $2.5/15 minutes
RATE_PER_15_MIN = 2.5

def generate_ticket(plate, parking_lot):
    ticket_id = str(uuid.uuid4())
    entry_time = datetime.utcnow()
    tickets[ticket_id] = {
        "plate": plate,
        "parking_lot": parking_lot,
        "entry_time": entry_time
    }
    return ticket_id

def close_ticket(ticket_id):
    now = datetime.utcnow()
    ticket = tickets.pop(ticket_id, None)
    if not ticket:
        return None

    duration = now - ticket["entry_time"]
    minutes_parked = duration.total_seconds() / 60
    increments = int((minutes_parked + 14) // 15)  # Round up to nearest 15-min
    total_cost = increments * RATE_PER_15_MIN

    return {
        "plate": ticket["plate"],
        "parking_lot": ticket["parking_lot"],
        "parked_minutes": int(minutes_parked),
        "total_cost": round(total_cost, 2)
    }
