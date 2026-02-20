-- ==========================================
-- ROLES
-- ==========================================
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
);

INSERT INTO roles (name) VALUES
('admin'),
('user'),
('moderator');

-- ==========================================
-- USERS
-- ==========================================
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    role_id INT REFERENCES roles(id),
    username VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (role_id, username, email, password_hash) VALUES
(1, 'blodyprincers', 'blody@example.com', 'hash123'),
(2, 'nataliasmrecek', 'natalia@example.com', 'hash456');

-- ==========================================
-- PROFILES
-- ==========================================
CREATE TABLE profiles (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES users(id) ON DELETE CASCADE,
    bio TEXT,
    avatar_url TEXT,
    birth_date DATE
);

INSERT INTO profiles (user_id, bio, avatar_url, birth_date) VALUES
(1, 'Administrator systemu', 'https://example.com/avatar1.png', '1998-05-12'),
(2, 'Zwykły użytkownik', 'https://example.com/avatar2.png', '2000-09-21');

-- ==========================================
-- POSTS
-- ==========================================
CREATE TABLE posts (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO posts (user_id, title, content) VALUES
(1, 'Pierwszy post', 'To jest pierwszy post administratora'),
(2, 'Witaj świecie', 'To mój pierwszy wpis');

-- ==========================================
-- COMMENTS
-- ==========================================
CREATE TABLE comments (
    id SERIAL PRIMARY KEY,
    post_id INT REFERENCES posts(id) ON DELETE CASCADE,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO comments (post_id, user_id, content) VALUES
(1, 2, 'Super wpis!'),
(2, 1, 'Witaj na platformie!');

-- ==========================================
-- ORDERS (przykład ecommerce)
-- ==========================================
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE SET NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO orders (user_id, total_amount, status) VALUES
(2, 199.99, 'completed'),
(2, 49.99, 'pending');
