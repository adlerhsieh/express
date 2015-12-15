require 'rails_helper'

describe PostsController, type: :controller do
  let(:user){create(:user)}
  let(:public_post){create(:post)}
  let(:private_post){create(:post, :private)}
  before do
    sign_in user 
    set_meta_tags
  end

  describe "#index" do
    it "in html" do
      get :index
      expect(response).to have_http_status(200)
      expect(response).to render_template(:index)
    end
  end

  describe "#show" do
    it 'in html' do
      get :show, slug: public_post.slug
      expect(response).to have_http_status(200)
    end
  end

  describe "#create" do
    let(:post_params){{
      :title => "new post",
      :slug => "new slug",
      :category => "未分類",
      :content => ["new ", "content"],
      :abstract => ["",""],
      :display_date => "2015/10/10"
    }}
    it 'saves a new post' do
      post :create, post_params
      expect(response).to have_http_status(200)
    end
  end
end
