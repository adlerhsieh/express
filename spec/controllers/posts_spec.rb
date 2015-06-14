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
    before { get :index }
    it { expect(response).to have_http_status(200) }
    it { expect(response).to render_template(:index) }
    # it { expect(response.body).to include(public_post.title) }
    # it { expect(response.body).not_to include(private_post.title) }
  end

  describe "#show" do
    before { get :show, slug: public_post.slug }
    it { expect(response).to have_http_status(200) }
  end
  # specify "#new" do
  #   get :new
  #   expect(response).to have_http_status(200)
  #   expect(response).to render_template(:new)
  # end
end
