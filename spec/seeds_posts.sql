TRUNCATE TABLE posts, user_accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (email_address, user_name) VALUES ('bobby_dazzler@who.com', 'BobbyDazzler4eva');
INSERT INTO user_accounts (email_address, user_name) VALUES ('rita_skeeter@news.com', 'RitaSkeeter_thewriter');
INSERT INTO posts (title, content, number_of_views, user_account_id) VALUES ('Magic is the best', 'I love magic', 3, 1);
INSERT INTO posts (title, content, number_of_views, user_account_id) VALUES ('Young wizzards are naughty', 'So I write bad things about them', 9, 2);