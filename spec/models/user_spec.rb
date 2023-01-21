require 'rails_helper'

RSpec.describe User, type: :model do
  it 'does not create an user without first name' do
    user = User.create(first_name: nil,
                       last_name: 'Name',
                       email: 'user@email.com',
                       password: 'password')

    expect(user.errors.messages[:first_name][0]).to eq("can't be blank")
  end

  it 'does not create an user without last name' do
    user = User.create(first_name: 'Sample',
                       last_name: nil,
                       email: 'user@email.com',
                       password: 'password')

    expect(user.errors.messages[:last_name][0]).to eq("can't be blank")
  end

  it 'does not create two users with the same email' do
    user = create(:user)
    user2 = User.create(first_name: 'Sample',
                        last_name: 'User 2',
                        email: user.email,
                        password: 'password')
    expect(user2.errors.messages[:email][0]).to eq("has already been taken")
  end
end