require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :request do
  before :each do
    @user = create(:user)
    @category = create(:category, user: @user)
    @category2 = create(:category,
                        name: "Category 2",
                        description: "Category 2 description",
                        user: @user)
    post '/users/sign_in', params: { user: { email: @user.email, password: @user.password } }
  end

  it "INDEX - gets categories related to the user" do
    get '/api/v1/categories'
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(parsed_body.count).to eq(2)
    expect(parsed_body.first['id']).to eq(@category.id)
    expect(parsed_body.last['id']).to eq(@category2.id)
  end

  it "SHOW - gets a category related to the user" do
    get "/api/v1/categories/#{@category2.id}"
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(parsed_body['id']).to eq(@category2.id)
    expect(parsed_body['name']).to eq('Category 2')
  end

  it "CREATE - creates an account related to the user" do
    categories_count = Category.all.size
    params = {
      category:
        {
          name: 'Category 3',
          description: 'Category 3 description'
        }
    }

    post "/api/v1/categories", params: params
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(201)
    expect(Category.all.size).to eq(categories_count + 1)
    expect(parsed_body['name']).to eq('Category 3')
    expect(parsed_body['description']).to eq('Category 3 description')
  end

  it "Updates - updates a category related to the user" do
    categories_count = Category.all.size
    params = {
      category:
        {
          name: 'Category 3',
          description: 'Category 3 description'
        }
    }

    patch "/api/v1/categories/#{@category2.id}", params: params
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(Category.all.size).to eq(categories_count)
    expect(parsed_body['name']).to eq('Category 3')
    expect(@category2.reload.name).to eq('Category 3')
    expect(parsed_body['description']).to eq('Category 3 description')
    expect(@category2.description).to eq('Category 3 description')
  end

  it "DESTROY - destroys a category related to the user" do
    categories_count = Category.all.size
    delete "/api/v1/categories/#{@category2.id}"
    parsed_body = JSON.parse(response.body)

    expect(response.status).to eq(200)
    expect(Category.all.size).to eq(categories_count - 1)
    expect(parsed_body['message']).to eq('Category successfully destroyed')
  end

  context 'when does not work returns an error message' do
    it "CREATE - does not create a category related to the user" do
      categories_count = Category.all.size
      params = {
        category:
          {
            name: 'Account 3',
            description: 'Account 3 description'
          }
      }

      allow_any_instance_of(Category).to receive(:save).and_return(false)
      post "/api/v1/categories", params: params

      expect(response.status).to eq(422)
      expect(Category.all.size).to eq(categories_count)
    end

    it "Updates - creates an account related to the user" do
      categories_count = Category.all.size
      params = {
        category:
          {
            name: 'Category 3',
            description: 'Category 3 description'
          }
      }

      allow_any_instance_of(Category).to receive(:update).and_return(false)
      patch "/api/v1/categories/#{@category2.id}", params: params

      expect(response.status).to eq(422)
      expect(Category.all.size).to eq(categories_count)
      expect(@category2.reload.name).not_to eq('Category 3')
      expect(@category2.description).not_to eq('Category 3 description')
    end

    it "DESTROY - destroys an account related to the user" do
      categories_count = Category.all.size
      allow_any_instance_of(Category).to receive(:destroy).and_return(false)
      delete "/api/v1/categories/#{@category2.id}"

      expect(response.status).to eq(422)
      expect(Category.all.size).to eq(categories_count)
    end
  end

  context 'for another user category' do
    before :each do
      @user2 = create(:user, email: 'user2@email.com')
      @category3 = create(:category,
                          name: "Category 3",
                          description: "Category 3 description",
                          user: @user2)
      @category4 = create(:category,
                          name: "Category 4",
                          description: "Category 4 description",
                          user: @user2)
    end

    it "INDEX - gets only categories related to the user" do
      get '/api/v1/categories'
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(parsed_body.count).to eq(2)
      expect(parsed_body.first['id']).to eq(@category.id)
      expect(parsed_body.last['id']).to eq(@category2.id)
    end

    it "SHOW - does not show" do
      get "/api/v1/categories/#{@category3.id}"
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(parsed_body['message']).to eq('You are not authorized')
    end

    it "UPDATE - does not update" do
      params = {
        category:
          {
            name: 'Category 5',
            description: 'Category 5 description'
          }
      }
      patch "/api/v1/categories/#{@category3.id}", params: params
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(parsed_body['message']).to eq('You are not authorized')
    end

    it "DESTROY - does not destroy" do
      delete "/api/v1/categories/#{@category3.id}"
      parsed_body = JSON.parse(response.body)

      expect(response.status).to eq(401)
      expect(parsed_body['message']).to eq('You are not authorized')
    end
  end
end