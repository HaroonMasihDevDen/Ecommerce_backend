class Product < ApplicationRecord

  has_many :category_products, dependent: :destroy
  has_many :categories, through: :category_products
  has_many :cart_items , dependent: :destroy
  has_many :order_products, dependent: :destroy
  has_many :orders, through: :order_products
  has_many :product_sizes, dependent: :destroy
  has_many :sizes, through: :product_sizes
  has_many_attached :images
  
  validate :correct_image_type
  validate :acceptable_image_size
  validates :images, presence: true
  validates :name , presence: true, uniqueness: true
  validates :description, presence: true
  validates :discount_percentage, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100
  }
  validates :discontinued, inclusion: { in: [true, false] }

  scope :active, -> { where(discontinued: false).where(deleted_at: nil) }
  scope :include_size_titles, ->(size_titles) {
    joins(:sizes).where(sizes: { name: size_titles }).distinct
  }

  def price
    product_sizes.where('quantity > ?',0).order(:price).first&.price
  end

  def self.low_stock_products
    active.joins(:product_sizes).select('products.*, SUM(product_sizes.quantity) AS total_stock').group('products.id').order('total_stock ASC').limit(5)
  end

  private

  def correct_image_type
    images.each do |image|
      unless image.content_type.in?(%w[image/png image/jpg image/jpeg image/webp])
        errors.add(:images, "must be a PNG, JPG, or JPEG")
      end
    end
  end

  def acceptable_image_size
    images.each do |image|
      if image.byte_size > 5.megabytes
        errors.add(:images, "should be less than 5MB")
      end
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[id product_id category_id name description discount_percentage discontinued created_at updated_at]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[category_products categories product_sizes sizes cart_items orders]
  end
end
