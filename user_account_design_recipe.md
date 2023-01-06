# User Accounts Model and Repository Classes Design Recipe

## 1. Design and create the Table
```
1. Name of the first table (always plural): `user_accounts` 

    Column names: `email address`, `username`
```

## 2. Create Test SQL seeds

Your tests will depend on data stored in PostgreSQL to run.

If seed data is provided (or you already created it), you can skip this step.

```sql
-- EXAMPLE
-- (file: spec/seeds_user_accounts.sql)

-- Write your SQL seed here. 

-- First, you'd need to truncate the table - this is so our table is emptied between each test run,
-- so we can start with a fresh state.
-- (RESTART IDENTITY resets the primary key)

TRUNCATE TABLE user_accounts RESTART IDENTITY; -- replace with your own table name.

-- Below this line there should only be `INSERT` statements.
-- Replace these statements with your own seed data.

INSERT INTO user_accounts (email_address, user_name) VALUES ('bobby_dazzler@who.com', 'BobbyDazzler4eva');
INSERT INTO user_accounts (email_address, user_name) VALUES ('rita_skeeter@news.com', 'RitaSkeeter_thewriter');
```

Run this SQL file on the database to truncate (empty) the table, and insert the seed data. Be mindful of the fact any existing records in the table will be deleted.

```bash
psql -h 127.0.0.1 your_database_name < seeds_user_accounts.sql
```

## 3. Define the class names

Usually, the Model class name will be the capitalised table name (single instead of plural). The same name is then suffixed by `Repository` for the Repository class name.

```ruby
# EXAMPLE
# Table name: students

# Model class
# (in lib/user_account.rb)
class UserAccount
end

# Repository class
# (in lib/user_account_repository.rb)
class UserAccountRepository
end
```

## 4. Implement the Model class

Define the attributes of your Model class. You can usually map the table columns to the attributes of the class, including primary and foreign keys.

```ruby
# EXAMPLE
# Table name: user_accounts

# Model class
# (in lib/user_account.rb)

class UserAccount

  # Replace the attributes by your own columns.
  attr_accessor :id, :email_address, :user_name
end

# The keyword attr_accessor is a special Ruby feature
# which allows us to set and get attributes on an object,
# here's an example:
#
# student = Student.new
# student.name = 'Jo'
# student.name
```

*You may choose to test-drive this class, but unless it contains any more logic than the example above, it is probably not needed.*

## 5. Define the Repository Class interface

Your Repository class will need to implement methods for each "read" or "write" operation you'd like to run against the database.

Using comments, define the method signatures (arguments and return value) and what they do - write up the SQL queries that will be used by each method.

```ruby
# EXAMPLE
# Table name: user_accounts

# Repository class
# (in lib/user_account_repository.rb)

class UserAccountRepository
  # Selecting all records
  # No arguments
  def all
    # Executes the SQL query:
    # SELECT id, email_address, user_name FROM user_accounts;

    # Returns an array of UserAccount objects.
  end
  # Gets a single record by its ID
  # One argument: the id (number)
  def find(id)
    # Executes the SQL query:
    # SELECT id, email_address, user_name FROM user_accounts WHERE id = $1;

    # Returns a single UserAccount object.
  end

  def create(user_account)
    # Executes the SQL query:
    # INSERT INTO user_accounts(email_address, user_name) VALUES($1, $2)
    # Returns nothing 
  end

  def delete(id)
    # DELETE FROM user_accounts WHERE id = $1
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
# Get all users

repo = UserAccountRepository.new

users = repo.all

users.length # =>  2

users[0].id # =>  1
users[0].email_address # => 'bobby_dazzler@who.com'
users[0].user_name # =>  'BobbyDazzler4eva'


# 2
# Get a single user

repo = UserAccountRepository.new

user = repo.find(1)

user.id # =>  1
user.email_address # => 'bobby_dazzler@who.com'
user.user_name # =>  'BobbyDazzler4eva'

# 3
# Creates a new user

repo = UserAccountRepository.new

new_user = UserAccount.new
new_user.email_address = 'harry@hogwarts.com'
new_user.user_name = 'harry_the_rebel'

user = repo.create(new_user)

# User include and have attributes when testing

all = repo.all

expect(all).to include (
  have_attributes (
    email_address: new_user.email_address,
    user_name: new_user.user_name
  )
)

# 4
# Deletes a user by id

repo = UserAccountRepository.new

user = repo.delete(1)

expect(all).not_to include (
  have_attributes (
    email_address: 'bobby_dazzler@who.com'
    user_name: 'BobbyDazzler4eva'
  )
)
```

Encode this example as a test.

## 7. Reload the SQL seeds before each test run

Running the SQL code present in the seed file will empty the table and re-insert the seed data.

This is so you get a fresh table contents every time you run the test suite.

```ruby
# EXAMPLE

# file: spec/user_account_repository_spec.rb

def reset_user_account_table
  seed_sql = File.read('spec/seeds_user_accounts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe UserAccountRepository do
  before(:each) do 
    reset_user_account_table
  end

  it "returns #all user accounts" do
    repo = UserAccountRepository.new
    users = repo.all
  
    expect(users.length).to eq(2)

    expect(users[0].id).to eq(1)
    expect(users[0].email_address).to eq('bobby_dazzler@who.com')
    expect(users[0].user_name).to eq('BobbyDazzler4eva')
  end


end
```

## 8. Test-drive and implement the Repository class behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._