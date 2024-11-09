USE sports_complex;

-- Insert sample users
INSERT INTO Users (Firstname, Surname, NetID, Card, Email, Phone, Social_credit, Birthday, `Role`, Member_status, Membership_creation_date, Outstanding_due)
VALUES 
('Alice', 'Johnson', 'aj123', 'CARD001', 'alice.johnson@example.com', '1234567890', 150, '2000-05-15', 'student', 'active', '2023-01-10', 0.00),
('Bob', 'Smith', 'bs456', 'CARD002', 'bob.smith@example.com', '0987654321', 90, '1995-11-20', 'faculty', 'expired', '2022-05-12', 50.00),
('Charlie', 'Brown', 'cb789', 'CARD003', 'charlie.brown@example.com', '1122334455', 75, '1980-02-17', 'staff', 'banned', '2020-08-23', 200.50),
('Daisy', 'Miller', 'dm101', 'CARD004', 'daisy.miller@example.com', '5566778899', 120, '1999-04-25', 'student_worker', 'active', '2023-03-15', 10.00),
('Edward', 'Jones', 'ej202', 'CARD005', 'edward.jones@example.com', '2233445566', 50, '1975-06-30', 'worker', 'restricted', '2021-07-09', 0.00),
('Fiona', 'Green', 'fg303', 'CARD006', 'fiona.green@example.com', '6677889900', 100, '1985-09-19', 'affiliate', 'active', '2022-12-01', 25.75),
('George', 'Martin', 'gm404', 'CARD007', 'george.martin@example.com', '7788990011', 200, '1992-07-04', 'alumni', 'active', '2022-10-05', 5.00),
('Helen', 'Clark', 'hc505', 'CARD008', 'helen.clark@example.com', '3344556677', 130, '2001-12-11', 'guest', 'expired', '2023-02-18', 100.00),
('Ian', 'Wright', 'iw606', 'CARD009', 'ian.wright@example.com', '4455667788', 110, '1993-03-09', 'security', 'active', '2023-01-22', 0.00),
('Jill', 'Adams', 'ja707', 'CARD010', 'jill.adams@example.com', '5566778890', 85, '2002-08-30', 'student', 'restricted', '2023-05-01', 15.25);

-- Insert users with boundary conditions for rigorous testing
INSERT INTO Users (Firstname, Surname, NetID, Card, Email, Phone, Social_credit, Birthday, `Role`, Member_status, Membership_creation_date, Outstanding_due)
VALUES
('Test', 'Zero', 'tz000', 'CARD011', 'test.zero@example.com', '0000000000', 0, '1990-01-01', 'guest', 'expired', '2020-01-01', 0.00), -- Boundary with zero values
('Test', 'Negative', 'tn999', 'CARD012', 'test.negative@example.com', '9999999999', -50, '2005-01-15', 'student', 'banned', '2023-05-01', -20.00), -- Negative social credit and due
('Long', 'NameTestUser', 'ln1234567890', 'CARD013', 'long.name.user@example.com', '1231231234', 100, '1999-09-09', 'faculty', 'active', '2023-01-15', 30.50); -- Longer NetID and names
