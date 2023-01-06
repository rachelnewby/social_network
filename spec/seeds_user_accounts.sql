TRUNCATE TABLE user_accounts, posts RESTART IDENTITY;  -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (email_address, user_name) VALUES ('bobby_dazzler@who.com', 'BobbyDazzler4eva');
INSERT INTO user_accounts (email_address, user_name) VALUES ('rita_skeeter@news.com', 'RitaSkeeter_thewriter');