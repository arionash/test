-- Enhanced Ticket Schema with Documentation

-- Drop tables if they exist
DROP TABLE IF EXISTS conversation_history;
DROP TABLE IF EXISTS ticket_tags;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS ticket_events;
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS systems;
DROP TABLE IF EXISTS users;

-- Table: users
-- Description: Contains both support agents and customers. Each user has a unique ID, a name, and a role.
-- Example data: Alice (agent), Bob (agent), Carol (customer), David (customer)
-- Useful queries:
--   SELECT * FROM users WHERE role = 'agent';
--   SELECT * FROM users WHERE name LIKE '%Smith%';
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT CHECK(role IN ('agent', 'customer')) NOT NULL
);

-- Table: systems
-- Description: Lists IT systems that may be affected by tickets (e.g. CRM, Billing Platform)
-- Example data: 'CRM', 'Billing Platform', 'Authentication Gateway'
-- Useful queries:
--   SELECT * FROM systems;
--   SELECT * FROM tickets WHERE system_id = 2; -- All tickets about Billing Platform
CREATE TABLE systems (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- Table: tickets
-- Description: Main support tickets. Links to users (reporter and assignee), system affected, and includes priority and status.
-- Useful queries:
--   SELECT * FROM tickets WHERE priority = 'urgent';
--   SELECT * FROM tickets WHERE status != 'closed';
--   SELECT * FROM tickets WHERE reporter_id = 3;
CREATE TABLE tickets (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    status TEXT CHECK(status IN ('open', 'in_progress', 'resolved', 'closed')) NOT NULL,
    priority TEXT CHECK(priority IN ('low', 'medium', 'high', 'urgent')) NOT NULL,
    created_at DATETIME NOT NULL,
    closed_at DATETIME,
    reporter_id INTEGER REFERENCES users(id),
    assignee_id INTEGER REFERENCES users(id),
    system_id INTEGER REFERENCES systems(id)
);

-- Table: ticket_events
-- Description: Chronological list of ticket activity (comments, assignments, status changes).
-- Useful queries:
--   SELECT * FROM ticket_events WHERE ticket_id = 101 ORDER BY timestamp;
--   SELECT * FROM ticket_events WHERE event_type = 'status_change';
CREATE TABLE ticket_events (
    id INTEGER PRIMARY KEY,
    ticket_id INTEGER REFERENCES tickets(id),
    timestamp DATETIME NOT NULL,
    event_type TEXT CHECK(event_type IN ('status_change', 'comment', 'assignment')),
    details TEXT
);

-- Table: tags
-- Description: Unique labels used to classify tickets.
-- Useful queries:
--   SELECT * FROM tags;
CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Table: ticket_tags
-- Description: Many-to-many relation between tickets and tags.
-- Useful queries:
--   SELECT t.* FROM tickets t
--   JOIN ticket_tags tt ON t.id = tt.ticket_id
--   JOIN tags tg ON tg.id = tt.tag_id
--   WHERE tg.name = 'High Priority';
CREATE TABLE ticket_tags (
    ticket_id INTEGER REFERENCES tickets(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (ticket_id, tag_id)
);

-- Table: conversation_history
-- Description: Logs messages exchanged about a ticket. Includes sender and timestamp.
-- Useful queries:
--   SELECT ch.*, u.name FROM conversation_history ch
--   JOIN users u ON ch.sender_id = u.id
--   WHERE ticket_id = 102 ORDER BY timestamp;
CREATE TABLE conversation_history (
    id INTEGER PRIMARY KEY,
    ticket_id INTEGER REFERENCES tickets(id),
    sender_id INTEGER REFERENCES users(id),
    message TEXT NOT NULL,
    timestamp DATETIME NOT NULL
);

-- Sample data for users
INSERT INTO users (id, name, role) VALUES
(1, 'Alice Smith', 'agent'),
(2, 'Bob Johnson', 'agent'),
(3, 'Carol Danvers', 'customer'),
(4, 'David Warner', 'customer'),
(5, 'Eve Torres', 'customer'),
(6, 'Frank Castle', 'agent');

-- Sample data for systems
INSERT INTO systems (id, name) VALUES
(1, 'CRM'),
(2, 'Billing Platform'),
(3, 'Authentication Gateway'),
(4, 'Reporting Engine');

-- Sample data for tags
INSERT INTO tags (id, name) VALUES
(1, 'Login Issue'),
(2, 'Data Loss'),
(3, 'Performance'),
(4, 'High Priority'),
(5, 'Feature Request'),
(6, 'Bug'),
(7, 'UI Feedback');

-- Sample data for tickets
INSERT INTO tickets (id, title, description, status, priority, created_at, closed_at, reporter_id, assignee_id, system_id) VALUES
(101, 'Login fails for multiple users', 'Users are reporting 403 errors when logging in.', 'resolved', 'high', '2025-05-01 08:30:00', '2025-05-01 12:00:00', 3, 1, 3),
(102, 'Incorrect billing total', 'Invoice #456 shows wrong total amount.', 'in_progress', 'urgent', '2025-05-02 09:00:00', NULL, 4, 2, 2),
(103, 'Request for report export feature', 'Customer would like CSV export in CRM.', 'open', 'low', '2025-05-03 10:15:00', NULL, 3, NULL, 1),
(104, 'System timeout under load', 'Dashboard fails to load under heavy usage.', 'open', 'medium', '2025-05-04 11:00:00', NULL, 5, 6, 4),
(105, 'Password reset email not sent', 'Several users are not receiving reset emails.', 'in_progress', 'high', '2025-05-05 14:00:00', NULL, 5, 1, 3);

-- Sample data for ticket_events
INSERT INTO ticket_events (ticket_id, timestamp, event_type, details) VALUES
(101, '2025-05-01 08:35:00', 'comment', 'User reported login issue.'),
(101, '2025-05-01 09:00:00', 'assignment', 'Assigned to Alice Smith'),
(101, '2025-05-01 11:45:00', 'status_change', 'Status changed to resolved'),
(102, '2025-05-02 09:10:00', 'comment', 'Billing discrepancy confirmed.'),
(102, '2025-05-02 09:30:00', 'assignment', 'Assigned to Bob Johnson'),
(104, '2025-05-04 11:30:00', 'comment', 'Reported timeouts during demo session.'),
(104, '2025-05-04 12:00:00', 'assignment', 'Assigned to Frank Castle');

-- Sample data for ticket_tags
INSERT INTO ticket_tags (ticket_id, tag_id) VALUES
(101, 1), (101, 4),
(102, 2), (102, 4),
(103, 5),
(104, 3), (104, 6),
(105, 1), (105, 4);

-- Sample data for conversation_history
INSERT INTO conversation_history (ticket_id, sender_id, message, timestamp) VALUES
(101, 3, 'Hello, I cannot log in and I keep seeing a 403 error.', '2025-05-01 08:30:00'),
(101, 1, 'Hi Carol, we are investigating the issue now.', '2025-05-01 08:45:00'),
(101, 3, 'Thanks, it’s urgent for our morning workflow.', '2025-05-01 09:00:00'),
(102, 4, 'The billing total is incorrect again. This is unacceptable.', '2025-05-02 09:05:00'),
(102, 2, 'We’re working on it. Please provide the invoice number.', '2025-05-02 09:10:00'),
(102, 4, 'Invoice #456. Fix it fast, this is not the first time!', '2025-05-02 09:15:00'),
(104, 5, 'The dashboard crashes every time during a sales call!', '2025-05-04 11:00:00'),
(104, 6, 'Thanks for reporting. We are increasing the timeout limits now.', '2025-05-04 12:00:00');
