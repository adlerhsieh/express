module DefaultSetter
  def author
    "Adler"
  end

  def default_display_date
    if not self.display_date
      self.update_column(:display_date, Date.today)
    end
  end

  def default_columns
    self.title = "無標題" if self.title == ""
    self.content = "" if self.content == ""
    self.slug = Time.now.strftime("%Y%m%d%H%M%S") if self.slug == ""
  end

  def default_category
    self.category_id = Category.create_with(slug: "uncategorized").find_or_create_by(name: "未分類")[:id] if self.category_id.nil?
  end

  def parse
    process = MarkdownHelper.new(self.content)
    process.parse_markdown
    # process.parse_code_block_style
    # process.remove_extras
    # return process.styled.html_safe
    return process.parsed.html_safe
  end

  def translate_CN
    Translator.new(self).to_CN unless I18n.locale == :"zh-CN"
  end
end
