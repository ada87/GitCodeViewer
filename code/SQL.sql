-- SQL Sample Code - Task Management Schema
--
-- @see https://dev.mysql.com/doc/

CREATE TABLE tasks (
    task_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    priority ENUM('low', 'medium', 'high', 'critical'),
    status ENUM('pending', 'in_progress', 'review', 'completed'),
    assignee VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO tasks (title, priority, status) VALUES
    ('Implement auth', 'high', 'in_progress');

SELECT COUNT(*) FROM tasks;
