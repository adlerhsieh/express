class PostsController < ApplicationController
  require 'redcarpet'
  require 'coderay'
  def index
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true)
    options = {
      :line_numbers => :table,
      :line_number_anchors => false,
      :css => :class
    }
    # rendered = markdown.render(File.read(File.expand_path("../red.rb", __FILE__)))
    raw = markdown.render(File.read(File.expand_path("../red.rb", __FILE__)))
    while index = raw =~ /<pre>/
      @content ||= ""
      @content += raw[0..index+4]
      raw = raw[index+5..-1]
      end_index = raw =~ />/
      @content += raw[0..end_index]
      raw = raw[end_index+1..-1]
      end_block_index = raw =~ /<\/code>/
      block = CodeRay.scan(raw[0...end_block_index], :ruby).html(options)   
      @content += block
      raw = raw[end_block_index-1..-1]
      end_block_end_index = raw =~ /<\/pre>/
      @content += raw[0..end_block_end_index+5]
      raw = raw[end_block_end_index+6..-1]
    end
    @content += raw
    @content.gsub!("&amp;quot;","&quot;") # 去除雙括號
    @content.gsub!('&amp;<span class="comment">#39;',"&#39;") # 去除單括號(Coderay誤認為註解)
    @content.gsub!('&amp;#39;</span>',"&#39;") # 去除單括號(Coderay誤認為註解的結尾)
    @content.gsub!('&amp;#39;',"&#39;") # 去除其他單括號
  end

  def new
  end

  def edit
  end

  def show
  end
end
