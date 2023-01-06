require 'database_connection'
require 'post'

class PostRepository
  def all
    sql = 'SELECT id, title, content, number_of_views, user_account_id FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])
    posts = result_set.map { |record| convert_to_post(record) }
    return posts
  end

  def find(id)
    sql = 'SELECT * FROM posts WHERE id = $1'
    result_set = DatabaseConnection.exec_params(sql, [id])
    result = convert_to_post(result_set[0])
    return result
  end

  def create(post)
    sql = 'INSERT INTO posts
          (title, content, number_of_views, user_account_id)
          VALUES($1, $2, $3, $4)'
    params = [post.title, post.content, post.number_of_views, post.user_account_id]
    DatabaseConnection.exec_params(sql, params)
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1'
    DatabaseConnection.exec_params(sql, [id])
  end

  private

  def convert_to_post(record)
    post = Post.new
    post.id = record['id'].to_i
    post.title = record['title']
    post.content = record['content']
    post.number_of_views = record['number_of_views'].to_i
    post.user_account_id = record['user_account_id'].to_i
    post
  end
end