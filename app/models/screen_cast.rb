class ScreenCast < ActiveRecord::Base
  belongs_to :training
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
  end

  def parse
    process = MarkdownHelper.new(self.content)
    process.parse_markdown
    process.parse_code_block_style
    process.remove_extras
    return process.styled.html_safe
  end

  def author
    "Adler"
  end
end
