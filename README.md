# Indian Railway Ticket Reservation System 🚆

### CS2202 Mini Project  
**Group Members:**
- Aayush Sheth – 2301CS02  
- Anish Raghashetty – 2301CS05  
- Aryan Phad – 2301CS09  

---

## 📘 Overview

This project simulates a **relational database-based Ticket Reservation System** for the Indian Railways. Implemented entirely in **MySQL**, it supports key functionalities such as:

- Ticket booking (Confirmed, RAC, Waiting)
- Availability and fare calculations
- RAC and Waiting list handling
- Ticket cancellation and refund management
- Comprehensive query and report support

---

## 🧩 System Features

- ✅ Book Tickets for multiple passengers  
- ✅ RAC and Waiting List Queue Management  
- ✅ PNR Status Check  
- ✅ Train Schedule Lookup  
- ✅ Automatic Refund Calculation on Cancellation  
- ✅ Total Revenue and Refund Analytics  

---

## 🗃️ Database Schema

The system includes the following tables:

- `stations` – Station details  
- `class` – Train class types and fare multipliers  
- `trains` – Train details and operating days  
- `routes` – Routes and station sequences for trains  
- `passengers` – Passenger details with category support  
- `seat` – Seat availability per train, class, and date  
- `ticket` – Ticket bookings  
- `payment` – Payment tracking  
- `rac_info` – RAC management  
- `wl_info` – Waiting list tracking  
- `refund_record` – Refund processing  

Each table is normalized to 3NF to ensure integrity and eliminate redundancy.

---

## 📊 ER Diagram and Relational Design

The ER diagram and normalized relational schema are available in the project report.  
Each entity is interlinked through appropriate **foreign key constraints**.

---

## ⚙️ Setup Instructions

1. **Install MySQL** and open MySQL Workbench.
2. **Create a new schema** (e.g., `miniproject`).
3. Import and run the SQL files to create tables and stored procedures.
4. Use the included procedures to simulate booking, cancellation, and queries.

---

## 🛠️ Key Stored Procedures

- `book_tickets(...)`  
  > Books tickets for multiple passengers with RAC/WL logic.

- `cancel_ticket(p_ticket_id)`  
  > Cancels a ticket and processes refunds with RAC/WL promotions.

- `get_trains_by_date(p_date)`  
  > Lists all trains running on the given date.

- `CheckPNRStatus(p_pnr)`  
  > Retrieves complete ticket and journey details for a PNR.

- `GetAvailableSeats(p_train_id, p_class_id, p_travel_date)`  
  > Shows available seats for a given class and date.

- `GetPassengerList(p_train_id, p_travel_date)`  
  > Lists all passengers traveling on a specific train and date.

---

## 📅 Usage Example

```sql
-- Book Tickets
CALL book_tickets('2025-04-16', '1001,1002,1003', 1, 101, 105, 12001, 'UPI');

-- Cancel Ticket
CALL cancel_ticket(1);

-- Trains running on a specific date
CALL get_trains_by_date('2025-04-16');

-- Check PNR Status
CALL CheckPNRStatus('PNR792699');
