class PostsController < ApplicationController
  require 'redcarpet'
  require 'coderay'
  def index
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
    # content = markdown.render(File.read())
    options = {
      :line_numbers => :table,
      :line_number_anchors => false,
      :css => :class
    }
    @content = CodeRay.scan(File.read(File.expand_path("../application_controller.rb", __FILE__)), :ruby).html(options)

  end

  def new
  end

  def edit
  end

  def show
  end
end
