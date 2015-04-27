class MarkdownHelper
  require 'coderay'
  require 'redcarpet'
  attr_accessor :raw, :parsed, :styled

  def initialize(raw)
    @raw = raw
    @parsed = ""
    @styled = ""
    @languages = [:ruby, :cmd, :javascript] 
    @coderay_options = {
      :line_numbers => :table,
      :line_number_anchors => false,
      :css => :class
    }
  end

  def remove_hexo_marks
    # @raw.gsub!('<div class="highlight-block">', "")
    # @raw.gsub!("<\/div>", "")
    @raw.gsub!("<snippet>", "`")
    @raw.gsub!("<\/snippet>", "`")
  end

  def convert_to_blockquotes
    while first_index = @raw =~ /<div class="highlight-block">/
    # first_index = @raw =~ /<div class="highlight-block">/
      end_index = @raw =~ /<\/div>/
      block = @raw[first_index..end_index+5]
      inserted = block.gsub("\n", "\n\n>")
      inserted.gsub!('<div class="highlight-block">', "")
      inserted.gsub!("</div>", "")
      @raw.gsub!(block, inserted)
    end
  end

  def parse_markdown
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, 
                                        fenced_code_blocks: true
                                       )
    @parsed = markdown.render(@raw)
  end

  def parse_code_block_style
    while first_index = @parsed =~ /<pre>/
      # parse pre tag
      closing_index = @parsed =~ /<\/pre>/
      height_multiplier =  @parsed[first_index...closing_index].count("\n")
      @styled += @parsed[0..first_index+4].gsub!("pre", "pre style='height:#{height(height_multiplier)}px;'")
      # parse coderay
      @parsed = @parsed[first_index+5..-1]
      end_index = @parsed =~ />/
      code_class = @parsed[0..end_index]
      @language = check_language(code_class)
      @styled += @parsed[0..end_index]
      @parsed = @parsed[end_index+1..-1]
      end_block_index = @parsed =~ /<\/code>/
      block = CodeRay.scan(@parsed[0...end_block_index], @language).html(@coderay_options)   
      @styled += block
      # add following content
      @parsed = @parsed[end_block_index-1..-1]
      end_block_end_index = @parsed =~ /<\/pre>/
      @styled += @parsed[0..end_block_end_index+5]
      @parsed = @parsed[end_block_end_index+6..-1]
    end
    @styled += @parsed
  end

  def parse_marks
    @styled.gsub!("&amp;quot;","&quot;") # 去除雙括號
    @styled.gsub!('&amp;<span class="comment">#39;',"&#39;") # 去除單括號(Coderay誤認為註解)
    @styled.gsub!('&amp;#39;</span>',"&#39;") # 去除單括號(Coderay誤認為註解的結尾)
    @styled.gsub!('&amp;#39;',"&#39;") # 去除其他單括號
  end

  private

    def check_language(class_attr)
      @languages.each do |lang|
        return lang if class_attr.index(lang.to_s)
      end
      :html
    end

    def height(multiplier)
      base = 35
      line_height = 20
      return (base + line_height * multiplier).to_s
    end

end
