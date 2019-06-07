class Product < ApplicationRecord
  include Filterable
  scope :category, -> (category) { where category: Category.find_by_name(category) }
  scope :brand, -> (brand) { where brand: Brand.find_by_name(cateogory) }
  scope :starts_with, -> (name) { where("name like ?", "#{name}%")}
  extend FriendlyId
  friendly_id :title, use: :slugged
  acts_as_votable
  belongs_to :category
  belongs_to :sub_category
  belongs_to :brand
  belongs_to :department
  has_many :shades, dependent: :destroy
  has_many :tutorials, through: :tutorial_products
  has_many :lookbooks, through: :lookbook_products
  has_many :insider_reviews
  has_many :customer_reviews
  monetize :price_cents
  has_many :product_benefits, dependent: :destroy
  has_many :benefits, through: :product_benefits
  has_many :sent_recommended_products, class_name: "RecommendedProduct", foreign_key: 'recommender_id', dependent: :destroy
  has_many :received_recommended_products, class_name: "RecommendedProduct", foreign_key: 'recommended_id', dependent: :destroy

  def average_rating
    if customer_reviews.count == 0
       0
    else
      sum = 0
      customer_reviews.each do |r|
        sum += r.rating
      end
      return sum / customer_reviews.count
    end
  end

  def total_reviews
    customer_reviews.count
  end



end
