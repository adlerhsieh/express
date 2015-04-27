class Post < ActiveRecord::Base
  require 'redcarpet'
  require 'coderay'

  belongs_to :category
  has_many :post_tags
  has_many :tags, :through => :post_tags

  def parse
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
    options = {
      :line_numbers => :table,
      :line_number_anchors => false,
      :css => :class
    }
    raw = MarkdownHelper.new(markdown.render(content))
    raw.parse_code_block
    raw.parse_marks
    return raw.parsed.html_safe
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
end
