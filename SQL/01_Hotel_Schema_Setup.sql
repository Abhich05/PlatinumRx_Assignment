-- ============================================================
-- 01_Hotel_Schema_Setup.sql
-- Hotel Management System — Table Creation & Sample Data
-- ============================================================

-- Drop tables if they already exist (for clean re-runs)
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS users;

-- ─────────────────────────────
-- TABLE: users
-- ─────────────────────────────
CREATE TABLE users (
    user_id         VARCHAR(50) PRIMARY KEY,
    name            VARCHAR(100) NOT NULL,
    phone_number    VARCHAR(15),
    mail_id         VARCHAR(100),
    billing_address TEXT
);

-- ─────────────────────────────
-- TABLE: bookings
-- ─────────────────────────────
CREATE TABLE bookings (
    booking_id      VARCHAR(50) PRIMARY KEY,
    booking_date    DATETIME NOT NULL,
    room_no         VARCHAR(50) NOT NULL,
    user_id         VARCHAR(50) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- ─────────────────────────────
-- TABLE: items
-- ─────────────────────────────
CREATE TABLE items (
    item_id     VARCHAR(50) PRIMARY KEY,
    item_name   VARCHAR(100) NOT NULL,
    item_rate   DECIMAL(10, 2) NOT NULL
);

-- ─────────────────────────────
-- TABLE: booking_commercials
-- ─────────────────────────────
CREATE TABLE booking_commercials (
    id              VARCHAR(50) PRIMARY KEY,
    booking_id      VARCHAR(50) NOT NULL,
    bill_id         VARCHAR(50) NOT NULL,
    bill_date       DATETIME NOT NULL,
    item_id         VARCHAR(50) NOT NULL,
    item_quantity   DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO users (user_id, name, phone_number, mail_id, billing_address) VALUES
('usr-001', 'John Doe',    '9712345678', 'john.doe@example.com',    '12, Street A, Mumbai'),
('usr-002', 'Jane Smith',  '9823456789', 'jane.smith@example.com',  '45, Street B, Delhi'),
('usr-003', 'Raj Kumar',   '9934567890', 'raj.kumar@example.com',   '78, Street C, Pune'),
('usr-004', 'Anita Desai', '9045678901', 'anita.desai@example.com', '90, Street D, Chennai');

INSERT INTO items (item_id, item_name, item_rate) VALUES
('itm-001', 'Tawa Paratha',   18.00),
('itm-002', 'Mix Veg',        89.00),
('itm-003', 'Paneer Butter',  149.00),
('itm-004', 'Cold Coffee',    65.00),
('itm-005', 'Masala Chai',    25.00),
('itm-006', 'Club Sandwich',  120.00);

INSERT INTO bookings (booking_id, booking_date, room_no, user_id) VALUES
('bk-001', '2021-09-10 14:00:00', 'rm-101', 'usr-001'),
('bk-002', '2021-10-05 10:30:00', 'rm-102', 'usr-002'),
('bk-003', '2021-10-15 09:00:00', 'rm-103', 'usr-001'),
('bk-004', '2021-10-20 11:00:00', 'rm-104', 'usr-003'),
('bk-005', '2021-11-01 12:00:00', 'rm-101', 'usr-004'),
('bk-006', '2021-11-10 15:00:00', 'rm-102', 'usr-002'),
('bk-007', '2021-11-18 08:00:00', 'rm-105', 'usr-003'),
('bk-008', '2021-12-01 16:00:00', 'rm-106', 'usr-001');

INSERT INTO booking_commercials (id, booking_id, bill_id, bill_date, item_id, item_quantity) VALUES
-- September bookings
('bc-001', 'bk-001', 'bl-001', '2021-09-10 19:00:00', 'itm-001', 2),
('bc-002', 'bk-001', 'bl-001', '2021-09-10 19:00:00', 'itm-002', 1),
-- October bookings
('bc-003', 'bk-002', 'bl-002', '2021-10-05 20:00:00', 'itm-003', 1),
('bc-004', 'bk-002', 'bl-002', '2021-10-05 20:00:00', 'itm-004', 2),
('bc-005', 'bk-002', 'bl-002', '2021-10-05 20:00:00', 'itm-005', 3),
('bc-006', 'bk-003', 'bl-003', '2021-10-15 21:00:00', 'itm-001', 5),
('bc-007', 'bk-003', 'bl-003', '2021-10-15 21:00:00', 'itm-006', 4),
('bc-008', 'bk-004', 'bl-004', '2021-10-20 18:00:00', 'itm-003', 3),
('bc-009', 'bk-004', 'bl-004', '2021-10-20 18:00:00', 'itm-005', 5),
-- November bookings
('bc-010', 'bk-005', 'bl-005', '2021-11-01 19:00:00', 'itm-002', 2),
('bc-011', 'bk-005', 'bl-005', '2021-11-01 19:00:00', 'itm-006', 3),
('bc-012', 'bk-006', 'bl-006', '2021-11-10 20:30:00', 'itm-001', 4),
('bc-013', 'bk-006', 'bl-006', '2021-11-10 20:30:00', 'itm-004', 2),
('bc-014', 'bk-006', 'bl-006', '2021-11-10 20:30:00', 'itm-003', 1),
('bc-015', 'bk-007', 'bl-007', '2021-11-18 12:00:00', 'itm-005', 6),
('bc-016', 'bk-007', 'bl-007', '2021-11-18 12:00:00', 'itm-002', 1),
-- December bookings
('bc-017', 'bk-008', 'bl-008', '2021-12-01 21:00:00', 'itm-003', 2),
('bc-018', 'bk-008', 'bl-008', '2021-12-01 21:00:00', 'itm-006', 5);
