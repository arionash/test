-- Drop tables if they exist
DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS ticket_events;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS systems;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS ticket_tags;

-- Users table: includes both agents and customers
CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    role TEXT CHECK(role IN ('agent', 'customer')) NOT NULL
);

-- Systems impacted by tickets
CREATE TABLE systems (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

-- Tickets table
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

-- Timeline of ticket events
CREATE TABLE ticket_events (
    id INTEGER PRIMARY KEY,
    ticket_id INTEGER REFERENCES tickets(id),
    timestamp DATETIME NOT NULL,
    event_type TEXT CHECK(event_type IN ('status_change', 'comment', 'assignment')),
    details TEXT
);

-- Tags table
CREATE TABLE tags (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

-- Ticket-to-tag many-to-many mapping
CREATE TABLE ticket_tags (
    ticket_id INTEGER REFERENCES tickets(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (ticket_id, tag_id)
);

-- Sample data

-- Users
INSERT INTO users (id, name, role) VALUES
(1, 'Alice Smith', 'agent'),
(2, 'Bob Johnson', 'agent'),
(3, 'Carol Danvers', 'customer'),
(4, 'David Warner', 'customer');

-- Systems
INSERT INTO systems (id, name) VALUES
(1, 'CRM'),
(2, 'Billing Platform'),
(3, 'Authentication Gateway');

-- Tags
INSERT INTO tags (id, name) VALUES
(1, 'Login Issue'),
(2, 'Data Loss'),
(3, 'Performance'),
(4, 'High Priority'),
(5, 'Feature Request');

-- Tickets
INSERT INTO tickets (id, title, description, status, priority, created_at, closed_at, reporter_id, assignee_id, system_id) VALUES
(101, 'Login fails for multiple users', 'Users are reporting 403 errors when logging in.', 'resolved', 'high', '2025-05-01 08:30:00', '2025-05-01 12:00:00', 3, 1, 3),
(102, 'Incorrect billing total', 'Invoice #456 shows wrong total amount.', 'in_progress', 'urgent', '2025-05-02 09:00:00', NULL, 4, 2, 2),
(103, 'Request for report export feature', 'Customer would like CSV export in CRM.', 'open', 'low', '2025-05-03 10:15:00', NULL, 3, NULL, 1);

-- Events
INSERT INTO ticket_events (ticket_id, timestamp, event_type, details) VALUES
(101, '2025-05-01 08:35:00', 'comment', 'User reported login issue.'),
(101, '2025-05-01 09:00:00', 'assignment', 'Assigned to Alice Smith'),
(101, '2025-05-01 11:45:00', 'status_change', 'Status changed to resolved'),
(102, '2025-05-02 09:10:00', 'comment', 'Billing discrepancy confirmed.'),
(102, '2025-05-02 09:30:00', 'assignment', 'Assigned to Bob Johnson');

-- Ticket-Tag mapping
INSERT INTO ticket_tags (ticket_id, tag_id) VALUES
(101, 1), -- Login Issue
(101, 4), -- High Priority
(102, 2), -- Data Loss
(102, 4), -- High Priority
(103, 5); -- Feature Request
