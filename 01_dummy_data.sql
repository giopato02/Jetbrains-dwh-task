INSERT INTO raw_subscriptions(sub_id, customer_id, plan_type, start_date, end_date, amount) VALUES
('S_101', 'C001', 'Annual', '2024-01-15', '2025-01-15', 1200.00),
('S_102', 'C002', 'Monthly', '2025-03-10', NULL, 50.00),
('S_103', 'C003', 'Monthly', '2024-06-01', '2025-08-01', 150.00);
INSERT INTO raw_customers(customer_id, company_name, country, signup_date) VALUES
('C001', 'JetBrains', 'Germany', '2023-01-15'),
('C002', 'Microsoft', 'USA', '2024-10-10'),
('C003', 'DataInc', 'Georgia', '2025-07-10');
INSERT INTO raw_transactions(tx_id, sub_id, tx_date, status) VALUES
('T_001', 'S_101', '2026-01-15', 'Success'),
('T_002', 'S_102', '2025-03-10', 'Success'),
('T_003', 'S_102', '2025-04-10', 'Success'),
('T_004', 'S_102', '2025-05-10', 'Failed'),
('T_005', 'S_103', '2025-06-01', 'Success'),
('T_006', 'S_103', '2025-07-01', 'Success'),
('T_006', 'S_103', '2025-07-01', 'Success'), -- INTENTIONAL DUPLICATE
('T_007', 'S_103', '2025-08-01', 'Refunded');