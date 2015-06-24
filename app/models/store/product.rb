class Store::Product < ActiveRecord::Base
  attr_accessor :image_1, :image_2, :image_3, :image_4, :image_5, :category
  validates_presence_of :title, :stock, :price, :default_image
  has_many :images, :class_name => "Store::Image", :foreign_key => "product_id"

  def update_images(new_images)
    current_images = self.images.map(&:image)
    new_images.each do |new_image|
      self.images.create(:image => new_image) if not current_images.include?(new_image)
    end
    (current_images - (current_images & new_images)).each do |image|
      self.images.find_by_image(image).delete
    end
  end
end
