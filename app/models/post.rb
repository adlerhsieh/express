class Post < ActiveRecord::Base
  require 'redcarpet'
  require 'coderay'

  belongs_to :category
  has_many :post_tags
  has_many :tags, :through => :post_tags

  def parse
    process = MarkdownHelper.new(self.content)
    process.remove_hexo_marks
    process.parse_markdown
    process.parse_code_block_style
    process.parse_marks
    return process.parsed.html_safe
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
