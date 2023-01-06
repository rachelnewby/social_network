# Posts Model and Repository Classes Design Recipe

## 1. Design and create the Table

```
Name of the second table: `posts` 

Column names: `title`, `content`, `number_of_views`, `user_account_id`
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_{table_name}.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE posts, user_accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (email_address, user_name) VALUES ('bobby_dazzler@who.com', 'BobbyDazzler4eva');
INSERT INTO user_accounts (email_address, user_name) VALUES ('rita_skeeter@news.com', 'RitaSkeeter_thewriter');
INSERT INTO posts (title, content, number_of_views, user_account_id) VALUES ('Magic is the best', 'I love magic', 3, 1);
INSERT INTO posts (title, content, number_of_views, user_account_id) VALUES ('Young wizzards are naughty', 'So I write bad things about them', 9, 2);

```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_posts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: posts

# Model class
# (in lib/post.rb)
class Post
end

# Repository class
# (in lib/post_repository.rb)
class PostRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: posts
# Model class
# (in lib/post.rb)
class Post
  attr_accessor :id, :title, :content, :number_of_views, :user_account_id
end

```

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: posts

# Repository class
# (in lib/post_repository.rb)

class PostRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, title, content, number_of_views, user_account_id FROM posts;
    # Returns an array of Post objects.
  end
  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, title, content, number_of_views, user_account_id FROM students WHERE id = $1;
    # Returns a single Post object.
  end

  def create(post)
    # Executes the SQL query:
    # INSERT INTO posts(title, content, number_of_views, user_account_id) VALUES($1, $2, $3, $4)
    # Returns nothing 
  end

  def delete(id)
    # DELETE FROM posts WHERE id = $1
    # Returns nothing
  end
end
```

## 6. Write Test Examples

Write Ruby code that defines the expected behaviour of the Repository class, following your design from the table written in step 5.

These examples will later be encoded as RSpec tests.

```ruby
# EXAMPLES

# 1
# Get all posts
repo = PostRepository.new
posts = repo.all

posts.length # =>  2

posts[0].id # =>  1
posts[0].title # =>  'Magic is the best'
posts[0].content # =>  'I love magic'
posts[0].number_of_views # => 3
posts[0].user_account_id # => 1

# 2
# Get a single student

repo = PostRepository.new

post = repo.find(1)

posts.id # =>  1
posts.title # =>  'Magic is the best'
posts.content # =>  'I love magic'
posts.number_of_views # => 3
posts.user_account_id # => 1

# 3
# Creates a post

repo = PostRepository.new

new_post = Post.new
new_post.title # => 'Going on holiday'
new_post.content # => 'Because I want to'
new_post.number_of_views #  => 0
new_post.user_account_id #  => 2

all = repo.all

expect(all).to include (
  have_attributes (
    title: new_post.title,
    content: new_post.content, 
    number_of_views: new_post.number_of_views, 
    user_account_id: new_post.user_account_id
  )
)

# 4
# Deletes a user by id

repo = UserAccountRepository.new

user = repo.delete(1)

expect(all).not_to include (
  have_attributes (
    title: 'Magic is the best',
    content: 'I love magic',
    number_of_views: 3, 
  )
)

```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/post_repository_spec.rb

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  # (your tests will go here).
end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._