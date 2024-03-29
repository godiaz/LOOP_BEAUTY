class Product < ApplicationRecord
  paginates_per 12
  include Filterable
  scope :sub_category, -> (sub_category) { where sub_category: SubCategory.product_filter(sub_category.reject(&:blank?)) }
  scope :brand, -> (brand) { where brand: Brand.product_filter(brand.reject(&:blank?)) }
  scope :starts_with, -> (name) { where("name like ?", "#{name}%")}
  extend FriendlyId
  has_one_attached :lead_product_image
  friendly_id :title, use: :slugged
  belongs_to :category
  belongs_to :sub_category
  belongs_to :brand
  belongs_to :department
  has_many :shades, dependent: :destroy
  has_many :uk_shades, -> { where(uk_available: true) }, class_name: 'Shade'
  has_many :us_shades, -> { where(us_available: true) }, class_name: 'Shade'
  has_many :tutorials, through: :tutorial_products
  has_many :lookbooks, through: :lookbook_products
  has_many :insider_reviews, dependent: :destroy
  has_many :customer_reviews, dependent: :destroy
  monetize :price_cents
  monetize :us_price_cents, with_currency: :usd
  has_many :showroom_products, dependent: :destroy
  has_many :product_benefits, dependent: :destroy
  has_many :tutorial_products, dependent: :destroy
  has_many :lookbook_products, dependent: :destroy
  has_many :wishlist_product, dependent: :destroy
  has_many :benefits, through: :product_benefits
  has_many :sent_recommended_products, class_name: "RecommendedProduct", foreign_key: 'recommender_id', dependent: :destroy
  has_many :received_recommended_products, class_name: "RecommendedProduct", foreign_key: 'recommended_id', dependent: :destroy
  has_many :products, through: :sent_recommended_products, source: :recommended
  include PgSearch::Model
  pg_search_scope :global_search,
    against: [ :title ],
    associated_against: {
      brand: [ :name ]
    },
    using: {
      tsearch: { prefix: true }
    }

  def average_rating
    if customer_reviews.count == 0
       0
    else
      sum = 0
      customer_reviews.each do |r|
        sum += r.rating
      end
      return (sum.to_f / customer_reviews.count).round(1)
    end
  end

  def total_number_of_items
    self.shades.sum(:number_in_stock)
  end

  def us_total_number_of_items
    self.shades.sum(:us_number_in_stock)
  end

  def out_of_stock?
    (self.shades.sum(:number_in_stock) == 0) ? true : false
  end

  def us_out_of_stock?
    (self.shades.sum(:us_number_in_stock) == 0) ? true : false
  end

  def total_reviews
    customer_reviews.count
  end

  def price_in(currency)
    info = ExchangeRate.find_by_currency(currency)
    return price unless info
    Money.new price_in_cents(currency), info.currency_code
  end

  def price_in_cents(currency)
    info = ExchangeRate.find_by_currency(currency)
    return price_cents unless info
    (price_cents * info.rate).round
  end

  def self.filter_sort(attr, direction)
    order(attr => direction.to_sym)
  end
end
