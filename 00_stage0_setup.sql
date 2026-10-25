-- Stage 0: tiny general-ledger dataset for the diagnostic exercises.
-- Run this once in an empty PostgreSQL database (e.g. fraud_lab).
-- Re-running is safe: it drops and recreates the tables.

DROP TABLE IF EXISTS journal_entries;
DROP TABLE IF EXISTS approval_limits;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    user_id   INT PRIMARY KEY,
    user_name TEXT NOT NULL,
    role      TEXT NOT NULL
);

CREATE TABLE accounts (
    account_id   INT PRIMARY KEY,
    account_name TEXT NOT NULL,
    account_type TEXT NOT NULL
);

-- Maximum amount each role may approve.
CREATE TABLE approval_limits (
    role         TEXT PRIMARY KEY,
    limit_amount NUMERIC(14,2) NOT NULL
);

CREATE TABLE journal_entries (
    je_id        INT PRIMARY KEY,
    posting_date DATE NOT NULL,
    amount       NUMERIC(14,2) NOT NULL,
    account_id   INT NOT NULL REFERENCES accounts(account_id),
    prepared_by  INT NOT NULL REFERENCES users(user_id),
    approved_by  INT NOT NULL REFERENCES users(user_id),
    description  TEXT
);

INSERT INTO users (user_id, user_name, role) VALUES
    (1, 'Asha',  'Accountant'),
    (2, 'Ravi',  'Accountant'),
    (3, 'Meera', 'Finance Manager'),
    (4, 'Karan', 'Finance Controller'),
    (5, 'Neha',  'Accountant');

INSERT INTO accounts (account_id, account_name, account_type) VALUES
    (1001, 'Cash',             'Asset'),
    (2001, 'Accounts Payable', 'Liability'),
    (4001, 'Sales Revenue',    'Revenue'),
    (5001, 'Office Expenses',  'Expense'),
    (5002, 'Consulting Fees',  'Expense'),
    (5003, 'Travel',           'Expense'),
    (6001, 'Suspense',         'Asset');

INSERT INTO approval_limits (role, limit_amount) VALUES
    ('Finance Manager',    200000.00),
    ('Finance Controller', 1000000.00);

INSERT INTO journal_entries
    (je_id, posting_date, amount, account_id, prepared_by, approved_by, description) VALUES
    ( 1, '2026-10-01',  45230.50, 5001, 1, 3, 'Stationery purchase'),
    ( 2, '2026-10-02', 128750.00, 5002, 2, 3, 'Consulting - Q3'),
    ( 3, '2026-10-03', 199500.00, 5002, 2, 3, 'Consulting - advisory'),
    ( 4, '2026-10-05',  67890.25, 5003, 5, 3, 'Travel reimbursement'),
    ( 5, '2026-10-06', 100000.00, 5002, 1, 3, 'Consulting - retainer'),
    ( 6, '2026-10-07',  23410.75, 5001, 5, 3, 'Printer supplies'),
    ( 7, '2026-10-08', 850000.00, 4001, 2, 4, 'Sales - bulk order'),
    ( 8, '2026-10-09',  12480.00, 5003, 1, 3, 'Taxi and lodging'),
    ( 9, '2026-10-10', 150000.00, 6001, 3, 3, 'Adjustment'),
    (10, '2026-10-12',  31275.40, 5001, 5, 3, 'Facility supplies'),
    (11, '2026-10-13',  78900.00, 5002, 2, 3, 'Consulting - audit support'),
    (12, '2026-10-13',  78900.00, 5002, 2, 3, 'Consulting - audit support'),
    (13, '2026-10-14', 199800.00, 5002, 2, 3, 'Consulting - strategy'),
    (14, '2026-10-15',  54320.10, 5003, 1, 3, 'Conference travel'),
    (15, '2026-10-16', 920000.00, 4001, 5, 4, 'Sales - Q3 contract'),
    (16, '2026-10-17',  49999.00, 5001, 5, 3, 'Misc expenses'),
    (17, '2026-10-19',  61250.65, 5001, 1, 3, 'Office furniture'),
    (18, '2026-10-20', 200000.00, 5002, 3, 3, 'Consulting - special project'),
    (19, '2026-10-21',  38740.20, 5003, 2, 3, 'Client visit'),
    (20, '2026-10-22',  17250.00, 5001, 5, 3, 'Cleaning contract');

-- Sanity check: should return 20.
SELECT COUNT(*) AS entry_count FROM journal_entries;
