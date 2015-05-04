require 'rails_helper'

describe PostsController, type: :controller do
  specify "#new" do
    user = create(:user)
    sign_in user
    get :new
    expect(response).to have_http_status(200)
  end
end
