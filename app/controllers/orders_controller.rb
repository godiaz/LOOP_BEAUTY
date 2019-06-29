class OrdersController < ApplicationController
  def new
    @basket = find_basket
    @order = Order.new
    authorize @order
  end

  def create
    @basket = find_basket
    @order = Order.new
    authorize @order
    @order.user = current_user
    authorize @order
    stripe_user = find_stripe_user(params[:stripeEmail], params[:stripeToken])
    charge = Stripe::Charge.create(
      customer: stripe_user.id,
      amount: @basket.total_price_cents,
      currency: @basket.total_price.currency
    )
    @order.stripe_id = charge.id
    if @order.save
      Stripe::Charge.update(
        charge.id,
        {
          description: "Payment for order #{@order.id} from #{current_user.email}"
        }
      )
      @basket.basket_products.each do |item|
        order_product = item.convert_to_order_product
        order_product.order = @order
        order_product.user = current_user
        order_product.save
      end
      @basket.empty!
      redirect_to order_path(@order)
    else
      flash[:error] = 'Error!'
      render :new
    end
  rescue Stripe::CardError => e
    flash[:alert] = e.message
    redirect_to checkout_path
  end

  def show
    @order = Order.find(params[:id])
    authorize @order
  end

  def find_stripe_user(email, token = nil)
    if current_user.stripe_id.nil?
      customer = Stripe::Customer.create(
        source: token,
        email: email
      )
      current_user.update(stripe_id: customer.id)
      customer
    else
      Stripe::Customer.retrieve(current_user.stripe_id)
    end
  end
end