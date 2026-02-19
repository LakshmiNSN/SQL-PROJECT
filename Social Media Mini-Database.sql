-- 1. Users Table
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Posts Table (1:M Relationship with Users)
CREATE TABLE posts (
    post_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 3. Comments Table (1:M Relationship with Users and Posts)
CREATE TABLE comments (
    comment_id SERIAL PRIMARY KEY,
    post_id INT NOT NULL,
    user_id INT NOT NULL,
    comment_text TEXT NOT NULL,
    CONSTRAINT fk_post_comment FOREIGN KEY(post_id) REFERENCES posts(post_id) ON DELETE CASCADE,
    CONSTRAINT fk_user_comment FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 4. Likes Table (M:M Relationship between Users and Posts)
CREATE TABLE likes (
    user_id INT NOT NULL,
    post_id INT NOT NULL,
    PRIMARY KEY (user_id, post_id),
    CONSTRAINT fk_user_like FOREIGN KEY(user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_post_like FOREIGN KEY(post_id) REFERENCES posts(post_id) ON DELETE CASCADE
);

-- 5. Follows Table (M:M Self-referencing Relationship for Users)
CREATE TABLE follows (
    follower_id INT NOT NULL,
    following_id INT NOT NULL,
    PRIMARY KEY (follower_id, following_id),
    CONSTRAINT fk_follower FOREIGN KEY(follower_id) REFERENCES users(user_id) ON DELETE CASCADE,
    CONSTRAINT fk_following FOREIGN KEY(following_id) REFERENCES users(user_id) ON DELETE CASCADE
);




--Populate Users (20+)

INSERT INTO users (username, email)
SELECT 
    'user_' || i, 
    'user' || i || '@example.com'
FROM generate_series(1, 25) s(i);

--Populate Posts (50+)
INSERT INTO posts (user_id, content)
SELECT 
    (random() * 24 + 1)::int, 
    'This is post number ' || i
FROM generate_series(1, 60) s(i);

--Populate Likes (100+)
-- Generates unique pairs to avoid PK violations
INSERT INTO likes (user_id, post_id)
SELECT DISTINCT
    (random() * 24 + 1)::int, 
    (random() * 59 + 1)::int
FROM generate_series(1, 150) s(i)
LIMIT 110;