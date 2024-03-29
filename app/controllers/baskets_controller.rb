class BasketsController < ApplicationController
  skip_before_action :authenticate_user!, except: [:abandon, :index]

  def show
    @basket = find_basket
    authorize @basket
  end

  def add_discount_code
    @basket = find_basket
    authorize @basket
    @code = params[:basket][:discount_code]
    @discount = DiscountCode.where(active: true).find_by_code(@code)
    @basket.discount_code = @discount if @discount.present?
    if @discount.present? && @basket.save
      respond_to do |format|
        format.html do
          flash[:notice] = 'Discount applied'
          redirect_to bag_path
        end
        format.js
      end
    else
      respond_to do |format|
        format.html do
          flash[:notice] = 'Discount not found'
          redirect_to bag_path
        end
        format.js
      end
    end
  end

  def index
    @baskets = policy_scope(Basket)
  end

  def recover
    @old_basket = Basket.find(params[:id])
    authorize @old_basket
    @basket.destroy
    @old_basket.update(recovered: true)
    redirect_to root_path
  end

  def abandoned_basket
    @abandoned_basket = Basket.find(params[:id])
    authorize @abandoned_basket
    unless @abandoned_basket.recovered?
      @basket.destroy
      @abandoned_basket.update(recovered: true)
      @basket = @abandoned_basket
    end
  end

  def remove_discount_code
    @basket = find_basket
    authorize @basket
    @basket.update(discount_code: nil)
    respond_to do |format|
      format.html { redirect_to bag_path, notice: "Discount code removed" }
      format.js
    end
  end
end
