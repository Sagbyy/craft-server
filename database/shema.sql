
-- Table users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table events
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    date TIMESTAMP WITH TIME ZONE NOT NULL,
    location VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table event_participants (jonction users ↔ events)
CREATE TABLE event_participants (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    event_id INT NOT NULL,
    joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id)   REFERENCES users(id)  ON DELETE CASCADE,
    FOREIGN KEY (event_id)  REFERENCES events(id) ON DELETE CASCADE
);
