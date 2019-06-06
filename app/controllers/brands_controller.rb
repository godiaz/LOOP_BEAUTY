class BrandsController < ApplicationController
  skip_before_action :authenticate_user!
  def index
    @brands = policy_scope(Brand)
  end

  def show
    @brand = Brand.friendly.find(params[:id])
    authorize @brand
    @products = @brand.products
  end
end
