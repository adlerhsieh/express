class Post < ActiveRecord::Base
  require 'redcarpet'
  require 'coderay'
  belongs_to :category
  has_many :post_tags
  has_many :tags, :through => :post_tags
  # validates :title, :content, :slug, :presence => true
  before_save :default_columns
  after_save :default_display_date

  def default_display_date
    if not self.display_date
      self.update_column(:display_date, Date.today)
    end
  end

  def default_columns
    self.title = "無標題" if self.title == ""
    self.content = "" if self.content == ""
    self.slug = Time.now.strftime("%Y%m%d%H%M%S") if self.slug == ""
    self.category_id = Category.create_with(slug: "uncategorized").find_or_create_by(name: "未分類")[:id] if self.category_id.nil?
  end

  def parse
    process = MarkdownHelper.new(self.content)
    process.remove_hexo_marks
    process.convert_to_blockquotes
    process.parse_markdown
    process.parse_code_block_style
    process.remove_extras
    return process.styled.html_safe
  end

  def author
    "Adler"
  end

  def self.group_by_year
    @posts = Post.includes(:category).order(:display_date => :desc)
    group_year = Post.order(:display_date => :desc).first[:display_date].strftime("%Y")
    @groups = {}
    posts = []
    @posts.each do |post|
      year = post[:display_date].strftime("%Y")
      if group_year != year
        @groups.merge!(group_year.to_sym => posts)
        posts = []
        group_year = year
      end
      posts.push(post)
      @groups.merge!(group_year.to_sym => posts) if post == @posts.last
    end
    @groups
  end

  private

end
