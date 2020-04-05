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
    self.title = "Unknown-#{Time.now.strftime("%Y%m%d%H%M%S")}"     unless self.title.present?
    self.slug = self.title.downcase.gsub(/[?!*]/, "").gsub(" ","-") unless self.slug.present?
  end

  def default_category
    if self.category_id.nil?
      self.category_id = Category.defualt_category.id
    end
  end

  def parse
    process = MarkdownHelper.new(self.content)
    process.parse_markdown
    # process.parse_code_block_style
    # process.remove_extras
    # return process.styled.html_safe
    return process.parsed.html_safe
  end
end
