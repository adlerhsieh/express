class Translator
  def initialize(source)
    attrs = {
      :title => [:title, :content],
      :name => [:name],
      :key => [:value]
    }
    @bing = BingTranslator.new("motionexpress","XElPnc0gckRHGyAgi7Y6wV8nxiLU4GDPDUivxrfRoYo=", false, 'FPiShpptVGkvVNAIGXoV//zHZMtvIAgsG/PiVSztHb8')
    @source = source
    @class = source.class
    attrs.each do |key, attributes|
      if @class.column_names.include? key.to_s
        @attributes = attributes
      end
    end
  end

  def to_CN
    target = "#{@class.to_s}::Translation".constantize.where(:locale => "zh-CN", "#{@class.to_s.downcase}_id".to_sym => @source[:id]).first_or_create
    @attributes.each do |key|
      content = @bing.translate(@source.send(key), from: "zh-TW", to: "zh-CN")
      compact(content)
      target.send("#{key}=", content)
    end
    target.save
  end

  private

  def compact(content)
    if content.nil?
      content
    else
      content.gsub!("! [", "![") 
      content.gsub!("` ``", "```") 
      content.gsub!("`` `", "```") 
      content.gsub!("对象", "物件") 
      content.gsub!("仿真", "模拟") 
      content.gsub!("正规表达式", "正则表达式") 
    end
  end
end
