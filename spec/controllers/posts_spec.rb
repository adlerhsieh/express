require 'rails_helper'

describe PostsController, type: :controller do
  let(:user){create(:user)}
  let(:public_post){create(:post)}
  let(:private_post){create(:post, :private)}
  before do
    sign_in user 
  end

  describe "#index" do
    before { get :index }
    it { expect(response).to have_http_status(200) }
    it { expect(response).to render_template(:index) }
  end

  specify "#new" do
    get :new
    expect(response).to have_http_status(200)
    expect(response).to render_template(:new)
  end
end
