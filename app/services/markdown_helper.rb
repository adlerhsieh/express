class MarkdownHelper
  require 'coderay'
  require 'redcarpet'
  attr_accessor :raw, :parsed, :styled

  def initialize(raw)
    @raw = raw
    @parsed = ""
    @styled = ""
    @languages = [:ruby, :cmd, :javascript, :json] 
    @coderay_options = {
      :line_numbers => :table,
      :line_number_anchors => false,
      :css => :class
    }
  end

  def parse_markdown
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, 
                                        fenced_code_blocks: true
                                       )
    @parsed = markdown.render(@raw || "")
  end

  # def remove_hexo_marks
  #   @raw.gsub!("<snippet>", "`")
  #   @raw.gsub!("<\/snippet>", "`")
  # end

  # def convert_to_blockquotes
  #   while first_index = @raw =~ /<div class="highlight-block">/
  #     end_index = @raw =~ /<\/div>/
  #     block = @raw[first_index..end_index+5]
  #     inserted = block.gsub("\n", "\n\n>")
  #     inserted.gsub!('<div class="highlight-block">', "")
  #     inserted.gsub!("</div>", "")
  #     @raw.gsub!(block, inserted)
  #   end
  # end


  # def parse_code_block_style
  #   while first_index = @parsed =~ /<pre>/
  #     # parse pre tag
  #     closing_index = @parsed =~ /<\/pre>/
  #     closing_index ||= @parsed.length - 1
  #     height_multiplier =  @parsed[first_index...closing_index].count("\n")
  #     @styled += @parsed[0..first_index+4].gsub!("pre", "pre style='height:#{height(height_multiplier)}px;'")
  #     # parse coderay
  #     @parsed = @parsed[first_index+5..-1]
  #     end_index = @parsed =~ />/
  #     code_class = @parsed[0..end_index]
  #     @language = check_language(code_class)
  #     @styled += @parsed[0..end_index]
  #     @parsed = @parsed[end_index+1..-1]
  #     end_block_index = @parsed =~ /<\/code>/
  #     end_block_index ||= @parsed.length - 1
  #     block = CodeRay.scan(@parsed[0...end_block_index], @language).html(@coderay_options).html_safe
  #     parse_custom_code_block_style(block, @language)
  #     @styled += block
  #     # add following content
  #     @parsed = @parsed[end_block_index-1..-1]
  #     end_block_end_index = @parsed =~ /<\/pre>/
  #     end_block_end_index ||= @parsed.length - 1
  #     @styled += @parsed[0..end_block_end_index+5]
  #     @parsed = @parsed[end_block_end_index+6..-1]
  #   end
  #   @styled += @parsed
  # end
  #
  # def parse_custom_code_block_style(code, lang)
  #   case lang
  #   when :ruby
  #     ["gem ", "require ", "require_relative ", "private", "include ", "it ", "do \n", " if "].each do |keyword|
  #       code.gsub!(keyword, "<span class='keyword'>#{keyword}</span>")
  #     end
  #   when :cmd
  #     code.gsub!("$", "<span class='prefix'>$</span>")
  #   end
  # end

  # def remove_extras
  #   # replace quotation marks in code block into string
  #   while @styled.index("&amp;quot;")
  #     @counter ||= 0
  #     if @counter == 0
  #       @styled.sub!("&amp;quot;","<span class='string'>&quot;")
  #     else
  #       @styled.sub!("&amp;quot;","&quot;</span>")
  #     end
  #     @counter = @counter == 0 ? 1 : 0
  #   end
  #   @styled.gsub!('&amp;<span class="comment">#39;',"&#39;") # 去除單括號(Coderay誤認為註解)
  #   @styled.gsub!('&amp;#39;</span>',"&#39;") # 去除單括號(Coderay誤認為註解的結尾)
  #   @styled.gsub!('&amp;#39;',"&#39;") # 去除其他單括號
  #   @styled.gsub!('&amp;gt;',"&gt;")
  #   @styled.gsub!('&amp;lt;',"&lt;")
  #   @styled.gsub!('&amp;',"&")
  # end

  private

    # def check_language(class_attr)
    #   @languages.each do |lang|
    #     return lang if class_attr.index(lang.to_s)
    #   end
    #   :html
    # end
    #
    # def height(multiplier)
    #   base = 35
    #   line_height = 20
    #   return (base + line_height * multiplier).to_s
    # end

end
