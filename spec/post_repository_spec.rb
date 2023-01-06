require_relative '../lib/post_repository'

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

describe PostRepository do
  before(:each) do 
    reset_posts_table
  end

  it "#all returns all posts in database " do
    repo = PostRepository.new
    posts = repo.all

    expect(posts.length).to eq(2)

    expect(posts[0].id).to eq(1)
    expect(posts[0].title).to eq('Magic is the best')
    expect(posts[0].content).to eq('I love magic')
    expect(posts[0].number_of_views).to eq(3)
    expect(posts[0].user_account_id).to eq(1)
  end

  it "#find takes an id as an argument and returns corresponding post instance" do
    repo = PostRepository.new
    post = repo.find(1)
    expect(post.id).to eq(1)
    expect(post.title).to eq('Magic is the best')
    expect(post.content).to eq('I love magic')
    expect(post.number_of_views).to eq(3)
    expect(post.user_account_id).to eq(1)
  end

  it "#create adds a new post to the database" do
  repo = PostRepository.new

  new_post = Post.new
  new_post.title = 'Going on holiday'
  new_post.content = 'Because I want to'
  new_post.number_of_views = 0
  new_post.user_account_id = 2
  post = repo.create(new_post)
  all = repo.all

  expect(all).to include (
    have_attributes(title: new_post.title,
                    content: new_post.content, 
                    number_of_views: new_post.number_of_views, 
                    user_account_id: new_post.user_account_id)
  )
  end

  it "#delete removes a post from the database" do
    repo = PostRepository.new

    user = repo.delete(1)

    expect(repo.all).not_to include (
      have_attributes(title: 'Magic is the best',
                      content: 'I love magic',
                      number_of_views: 3)
      )
  end

end


