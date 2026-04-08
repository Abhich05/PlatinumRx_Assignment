-- ============================================================
-- 03_Clinic_Schema_Setup.sql
-- Clinic Management System — Table Creation & Sample Data
-- ============================================================

DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

-- ─────────────────────────────
-- TABLE: clinics
-- ─────────────────────────────
CREATE TABLE clinics (
    cid         VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100) NOT NULL,
    city        VARCHAR(100),
    state       VARCHAR(100),
    country     VARCHAR(100)
);

-- ─────────────────────────────
-- TABLE: customer
-- ─────────────────────────────
CREATE TABLE customer (
    uid     VARCHAR(50) PRIMARY KEY,
    name    VARCHAR(100) NOT NULL,
    mobile  VARCHAR(15)
);

-- ─────────────────────────────
-- TABLE: clinic_sales
-- ─────────────────────────────
CREATE TABLE clinic_sales (
    oid           VARCHAR(50) PRIMARY KEY,
    uid           VARCHAR(50) NOT NULL,
    cid           VARCHAR(50) NOT NULL,
    amount        DECIMAL(12, 2) NOT NULL,
    datetime      DATETIME NOT NULL,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ─────────────────────────────
-- TABLE: expenses
-- ─────────────────────────────
CREATE TABLE expenses (
    eid         VARCHAR(50) PRIMARY KEY,
    cid         VARCHAR(50) NOT NULL,
    description VARCHAR(200),
    amount      DECIMAL(12, 2) NOT NULL,
    datetime    DATETIME NOT NULL,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO clinics (cid, clinic_name, city, state, country) VALUES
('cnc-001', 'HealthFirst Clinic',  'Mumbai',    'Maharashtra', 'India'),
('cnc-002', 'CityMed Centre',      'Pune',      'Maharashtra', 'India'),
('cnc-003', 'WellCare Clinic',     'Bangalore', 'Karnataka',   'India'),
('cnc-004', 'PrimeCare Hospital',  'Mysore',    'Karnataka',   'India'),
('cnc-005', 'QuickHeal Clinic',    'Chennai',   'Tamil Nadu',  'India'),
('cnc-006', 'LifeLine Medical',    'Coimbatore','Tamil Nadu',  'India');

INSERT INTO customer (uid, name, mobile) VALUES
('cust-001', 'Amit Sharma',   '9911111111'),
('cust-002', 'Priya Nair',    '9922222222'),
('cust-003', 'Rahul Mehta',   '9933333333'),
('cust-004', 'Sunita Joshi',  '9944444444'),
('cust-005', 'Vikram Singh',  '9955555555'),
('cust-006', 'Deepa Pillai',  '9966666666'),
('cust-007', 'Arjun Patel',   '9977777777'),
('cust-008', 'Meena Reddy',   '9988888888');

-- clinic_sales — spread across 2021, multiple channels & clinics
INSERT INTO clinic_sales (oid, uid, cid, amount, datetime, sales_channel) VALUES
('ord-001', 'cust-001', 'cnc-001',  2499.00, '2021-01-05 10:00:00', 'online'),
('ord-002', 'cust-002', 'cnc-001',  1800.00, '2021-01-12 11:30:00', 'walk-in'),
('ord-003', 'cust-003', 'cnc-002',  3200.00, '2021-02-03 09:00:00', 'online'),
('ord-004', 'cust-004', 'cnc-002',   950.00, '2021-02-14 14:00:00', 'referral'),
('ord-005', 'cust-001', 'cnc-003',  4100.00, '2021-03-08 12:00:00', 'walk-in'),
('ord-006', 'cust-005', 'cnc-003',  2250.00, '2021-03-20 16:00:00', 'online'),
('ord-007', 'cust-006', 'cnc-004',  1300.00, '2021-04-02 10:30:00', 'referral'),
('ord-008', 'cust-007', 'cnc-005',  5000.00, '2021-04-18 09:00:00', 'online'),
('ord-009', 'cust-008', 'cnc-005',  3750.00, '2021-05-07 15:00:00', 'walk-in'),
('ord-010', 'cust-002', 'cnc-006',  2100.00, '2021-05-22 11:00:00', 'online'),
('ord-011', 'cust-003', 'cnc-001',  1600.00, '2021-06-10 10:00:00', 'referral'),
('ord-012', 'cust-004', 'cnc-002',  4400.00, '2021-06-25 13:00:00', 'online'),
('ord-013', 'cust-005', 'cnc-003',  3300.00, '2021-07-04 09:30:00', 'walk-in'),
('ord-014', 'cust-006', 'cnc-004',  2800.00, '2021-07-19 14:30:00', 'online'),
('ord-015', 'cust-007', 'cnc-005',  1950.00, '2021-08-05 11:00:00', 'referral'),
('ord-016', 'cust-008', 'cnc-006',  4600.00, '2021-08-21 15:30:00', 'walk-in'),
('ord-017', 'cust-001', 'cnc-001',  5200.00, '2021-09-09 10:00:00', 'online'),
('ord-018', 'cust-002', 'cnc-002',  3100.00, '2021-09-28 09:00:00', 'online'),
('ord-019', 'cust-003', 'cnc-003',  2700.00, '2021-10-11 12:00:00', 'walk-in'),
('ord-020', 'cust-004', 'cnc-004',  1400.00, '2021-10-27 16:00:00', 'referral'),
('ord-021', 'cust-005', 'cnc-005',  4900.00, '2021-11-06 10:30:00', 'online'),
('ord-022', 'cust-006', 'cnc-006',  3500.00, '2021-11-19 14:00:00', 'online'),
('ord-023', 'cust-007', 'cnc-001',  2200.00, '2021-12-03 11:00:00', 'walk-in'),
('ord-024', 'cust-008', 'cnc-002',  4750.00, '2021-12-20 15:00:00', 'referral');

-- expenses — one or two entries per clinic per month
INSERT INTO expenses (eid, cid, description, amount, datetime) VALUES
('exp-001', 'cnc-001', 'Staff salaries',       18000.00, '2021-01-31 00:00:00'),
('exp-002', 'cnc-001', 'Medical supplies',       1200.00, '2021-01-15 00:00:00'),
('exp-003', 'cnc-002', 'Rent',                  10000.00, '2021-02-01 00:00:00'),
('exp-004', 'cnc-002', 'Utilities',               800.00, '2021-02-20 00:00:00'),
('exp-005', 'cnc-003', 'Staff salaries',        22000.00, '2021-03-31 00:00:00'),
('exp-006', 'cnc-003', 'Equipment maintenance',  2500.00, '2021-03-10 00:00:00'),
('exp-007', 'cnc-004', 'Rent',                   8000.00, '2021-04-01 00:00:00'),
('exp-008', 'cnc-005', 'Staff salaries',        19000.00, '2021-04-30 00:00:00'),
('exp-009', 'cnc-005', 'Medical supplies',       1500.00, '2021-05-15 00:00:00'),
('exp-010', 'cnc-006', 'Utilities',               900.00, '2021-05-20 00:00:00'),
('exp-011', 'cnc-001', 'Staff salaries',        18000.00, '2021-06-30 00:00:00'),
('exp-012', 'cnc-002', 'Medical supplies',        600.00, '2021-06-10 00:00:00'),
('exp-013', 'cnc-003', 'Rent',                  12000.00, '2021-07-01 00:00:00'),
('exp-014', 'cnc-004', 'Staff salaries',        15000.00, '2021-07-31 00:00:00'),
('exp-015', 'cnc-005', 'Utilities',               700.00, '2021-08-15 00:00:00'),
('exp-016', 'cnc-006', 'Medical supplies',       1100.00, '2021-08-20 00:00:00'),
('exp-017', 'cnc-001', 'Staff salaries',        18000.00, '2021-09-30 00:00:00'),
('exp-018', 'cnc-002', 'Rent',                  10000.00, '2021-09-01 00:00:00'),
('exp-019', 'cnc-003', 'Medical supplies',       2000.00, '2021-10-15 00:00:00'),
('exp-020', 'cnc-004', 'Equipment maintenance',  3500.00, '2021-10-20 00:00:00'),
('exp-021', 'cnc-005', 'Staff salaries',        19000.00, '2021-11-30 00:00:00'),
('exp-022', 'cnc-006', 'Rent',                   7000.00, '2021-11-01 00:00:00'),
('exp-023', 'cnc-001', 'Medical supplies',       1000.00, '2021-12-10 00:00:00'),
('exp-024', 'cnc-002', 'Staff salaries',        16000.00, '2021-12-31 00:00:00');
