from flask import Flask, request, jsonify
from app.parking import generate_ticket, close_ticket

app = Flask(__name__)

@app.route("/entry", methods=["POST"])
def entry():
    plate = request.args.get("plate")
    lot = request.args.get("parkingLot")
    if not plate or not lot:
        return jsonify({"error": "Missing plate or parkingLot"}), 400

    ticket_id = generate_ticket(plate, lot)
    return jsonify({"ticketId": ticket_id})

@app.route("/exit", methods=["POST"])
def exit():
    ticket_id = request.args.get("ticketId")
    if not ticket_id:
        return jsonify({"error": "Missing ticketId"}), 400

    result = close_ticket(ticket_id)
    if not result:
        return jsonify({"error": "Ticket not found"}), 404

    return jsonify(result)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
