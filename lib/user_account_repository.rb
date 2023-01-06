require 'database_connection'
require 'user_account'

class UserAccountRepository
  def all
    sql = 'SELECT id, email_address, user_name FROM user_accounts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    users = result_set.map { |results| convert_to_user_account(results) }
    return users
  end

  def find(id)
    sql = 'SELECT * FROM user_accounts WHERE id = $1;'
    result_set = DatabaseConnection.exec_params(sql, [id])
    result = convert_to_user_account(result_set[0])
    return result
  end

  def create(user)
    sql = 'INSERT INTO user_accounts(email_address, user_name) VALUES($1, $2)'
    params = [user.email_address, user.user_name]
    DatabaseConnection.exec_params(sql, params)
  end

  def delete(id)
    sql = 'DELETE FROM user_accounts WHERE id = $1'
    DatabaseConnection.exec_params(sql, [id])
  end

  private 

  def convert_to_user_account(record)
      user = UserAccount.new
      user.id = record['id'].to_i
      user.email_address = record['email_address']
      user.user_name = record['user_name']
      user
  end
end
