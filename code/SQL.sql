-- ==============================================================================
-- GitCode Viewer - Database Schema Mockup
-- Database: PostgreSQL / SQLite Compatible
-- ==============================================================================

-- Create Tables

CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    is_premium BOOLEAN DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS repositories (
    repo_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    remote_url VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    local_path VARCHAR(255),
    is_private BOOLEAN DEFAULT FALSE,
    sync_status VARCHAR(20) DEFAULT 'synced', -- synced, pending, error
    last_synced_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT unique_user_repo UNIQUE (user_id, remote_url)
);

CREATE TABLE IF NOT EXISTS settings (
    setting_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id) ON DELETE CASCADE,
    theme_preference VARCHAR(20) DEFAULT 'system', -- light, dark, system
    font_size INTEGER DEFAULT 14,
    show_line_numbers BOOLEAN DEFAULT TRUE,
    auto_fetch BOOLEAN DEFAULT TRUE,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS search_history (
    history_id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(user_id),
    query VARCHAR(255) NOT NULL,
    searched_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create Indexes for Performance
CREATE INDEX idx_repo_user ON repositories(user_id);
CREATE INDEX idx_repo_name ON repositories(name);
CREATE INDEX idx_search_query ON search_history(query);

-- Insert Dummy Data (Seed)

BEGIN;

INSERT INTO users (username, email, password_hash, is_premium) VALUES 
('alice_dev', 'alice@example.com', 'hashed_secret_123', TRUE),
('bob_coder', 'bob@example.com', 'hashed_secret_456', FALSE),
('charlie_new', 'charlie@example.com', 'hashed_secret_789', FALSE);

-- Alice's Repos
INSERT INTO repositories (user_id, remote_url, name, is_private, last_synced_at) VALUES
((SELECT user_id FROM users WHERE username = 'alice_dev'), 'https://github.com/facebook/react.git', 'react', FALSE, NOW()),
((SELECT user_id FROM users WHERE username = 'alice_dev'), 'https://github.com/company/secret-project.git', 'secret-project', TRUE, NOW() - INTERVAL '1 hour');

-- Bob's Repos
INSERT INTO repositories (user_id, remote_url, name, is_private) VALUES
((SELECT user_id FROM users WHERE username = 'bob_coder'), 'https://github.com/golang/go.git', 'go', FALSE);

-- Settings
INSERT INTO settings (user_id, theme_preference, font_size) VALUES
((SELECT user_id FROM users WHERE username = 'alice_dev'), 'dark', 16),
((SELECT user_id FROM users WHERE username = 'bob_coder'), 'light', 12);

COMMIT;

-- Queries for Application Logic

-- 1. Get all repositories for a specific user
SELECT r.name, r.remote_url, r.last_synced_at 
FROM repositories r
JOIN users u ON r.user_id = u.user_id
WHERE u.username = 'alice_dev'
ORDER BY r.last_synced_at DESC;

-- 2. Check if a user is premium
SELECT is_premium FROM users WHERE email = 'alice@example.com';

-- 3. Update sync status
UPDATE repositories 
SET sync_status = 'error', last_synced_at = NOW() 
WHERE repo_id = 1;

-- 4. Analytics: Count repos per user
SELECT u.username, COUNT(r.repo_id) as repo_count
FROM users u
LEFT JOIN repositories r ON u.user_id = r.user_id
GROUP BY u.username
HAVING COUNT(r.repo_id) > 0;

-- 5. Stored Procedure (Example)
-- Function to register a new repo search
CREATE OR REPLACE FUNCTION log_search(u_id INT, search_term VARCHAR) 
RETURNS VOID AS $$
BEGIN
    INSERT INTO search_history (user_id, query) 
    VALUES (u_id, search_term);
    
    -- Keep only last 100 entries per user
    DELETE FROM search_history 
    WHERE history_id NOT IN (
        SELECT history_id FROM search_history 
        WHERE user_id = u_id 
        ORDER BY searched_at DESC 
        LIMIT 100
    );
END;
$$ LANGUAGE plpgsql;

-- Trigger: Update timestamp on settings change
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_timestamp
BEFORE UPDATE ON settings
FOR EACH ROW
EXECUTE PROCEDURE update_timestamp();

-- End of Schema