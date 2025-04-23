# Ticket Reservation System

## CS2202 Mini Project  
**Group Members:**
- Aayush Sheth – 2301CS02  
- Anish Raghashetty – 2301CS05  
- Aryan Phad – 2301CS09  

---

## Project Overview

This project implements a Ticket Reservation System using a relational database model in MySQL. It is designed to simulate the core functionalities of an Indian Railways reservation system, including seat booking, RAC/waiting list management, ticket cancellation with refunds, and basic analytics.

---

## Features

- Ticket booking for multiple passengers
- Seat allocation based on availability
- RAC (Reservation Against Cancellation) and Waiting List handling
- Ticket cancellation with automated refund processing
- Train schedule and seat availability queries
- PNR status tracking
- Revenue and refund reports

---

## Database Schema

The system consists of the following tables:

- `stations` – Stores station information
- `class` – Defines classes of travel and fare multipliers
- `trains` – Holds details of trains and their schedules
- `routes` – Maps stations to trains with sequence
- `passengers` – Stores passenger data with categories
- `seat` – Seat availability by train, class, and date
- `ticket` – Stores ticket bookings
- `payment` – Tracks payments made for tickets
- `rac_info` – RAC queue data
- `wl_info` – Waiting list tracking
- `refund_record` – Records processed refunds

Each table is normalized to 3NF and linked using appropriate foreign keys.

---

## ER Diagram and Relational Model

A complete Entity-Relationship diagram and relational schema are included in the project report. The schema ensures referential integrity and eliminates redundancy.

---

## Setup Instructions

1. Install MySQL and open MySQL Workbench.
2. Create a new database schema (e.g., `miniproject`).
3. Import the provided SQL scripts to create tables and stored procedures.
4. Use stored procedures to simulate booking, cancellation, and queries.

---

## Stored Procedures

- `book_tickets(...)` – Books tickets and handles RAC/WL logic.
- `cancel_ticket(p_ticket_id)` – Cancels a ticket, processes refund, and promotes RAC/WL entries.
- `get_trains_by_date(p_date)` – Returns trains operating on a given date based on their schedule.
- `CheckPNRStatus(p_pnr)` – Displays ticket status and details for a given PNR.
- `GetAvailableSeats(p_train_id, p_class_id, p_travel_date)` – Shows available seats for specified criteria.
- `GetPassengerList(p_train_id, p_travel_date)` – Lists passengers for a train on a specific date.

---

## Sample Usage

```sql
-- Booking example
CALL book_tickets('2025-04-16', '1001,1002,1003', 1, 101, 105, 12001, 'UPI');

-- Cancel ticket
CALL cancel_ticket(1);

-- Check trains running on a date
CALL get_trains_by_date('2025-04-16');

-- Check PNR status
CALL CheckPNRStatus('PNR792699');
