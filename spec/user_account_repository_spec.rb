require_relative '../lib/user_account_repository'

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

  it "#find takes id as argument and returns corresponding user account" do
    repo = UserAccountRepository.new
    user = repo.find(1)

    expect(user.email_address).to eq('bobby_dazzler@who.com')
    expect(user.user_name).to eq('BobbyDazzler4eva')
  end

  it "#create creates a new user in the database" do
    repo = UserAccountRepository.new
    new_user = UserAccount.new
    new_user.email_address = 'harry@hogwarts.com'
    new_user.user_name = 'harry_the_rebel'
    user = repo.create(new_user)  
    all = repo.all
    expect(all).to include (
      have_attributes(email_address: new_user.email_address, user_name: new_user.user_name)
    )
  end

  it "#delete removes a user from the database" do
    repo = UserAccountRepository.new
    repo.delete(1)

    expect(repo.all).not_to include (
      have_attributes(email_address: 'bobby_dazzler@who.com', user_name: 'BobbyDazzler4eva')
    )
  end

end