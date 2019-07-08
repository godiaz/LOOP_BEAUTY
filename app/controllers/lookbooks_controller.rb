class LookbooksController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show, :index]
  before_action :set_lookbook, only: [:edit, :update, :destroy]

  def index
    # @lookbooks = policy_scope(Lookbook).where(user: params[:user_id])

    @user = User.find((User.select { |u| u.slug == params[:user_id] }).first.id)
    @lookbooks = policy_scope(Lookbook).where(user: User.select { |u| u.slug == params[:user_id] })
  end

  def show

    # NOT SURE IF CORRECT BUT WORKS
    user = User.find(params[:user_id])
    @lookbook = Lookbook.find((Lookbook.select{ |r| r.slug == params[:id]}).first.id)
    @lookbooks = Lookbook.where(user: user)
    authorize @lookbook
    @previous_lookbook = @lookbooks[@lookbook == @lookbooks.first ? @lookbooks.last.id - 1 : @lookbook.id - 2]
    @next_lookbook = @lookbooks[@lookbook == @lookbooks.last ? @lookbooks.first.id - 1 : @lookbook.id]
  end

  def new
    @lookbook = Lookbook.new
    @user = current_user
    authorize @lookbook
  end

  def create
    @lookbook = Lookbook.new(lookbook_params)
    @lookbook.user = current_user
    authorize @lookbook
    if @lookbook.save
      flash[:notice] = 'Lookbook pending approval'
      redirect_to root_path
    else
      raise
      flash[:error] = 'Please review problems'
      render :new
    end
  end

  def edit
  end

  def update
    if @lookbook.update(lookbook_params)
      flash[:notice] = 'Lookbook updated'
      redirect_to root_path
    else
      flash[:error] = 'Please review problems'
      render :edit
    end
  end

  def destroy
    if @lookbook.destroy
      flash[:notice] = 'Lookbook deleted'
      redirect_to root_path
    end
  end

  def approve
    @lookbook.approve!
    redirect_to admin_lookbooks_path
  end

  def reject
    @lookbook.update(lookbook_params)
    @lookbook.reject!
    redirect_to admin_lookbooks_path
  end

  private

  def set_lookbook
    # @lookbook = Lookbook.friendly.find(params[:id])

    # NOT SURE IF CORRECT BUT WORKS
    user = User.select { |u| u.slug == params[:id] }.first
    @lookbook = Lookbook.find(user.id)
    authorize @lookbook
  end

  def lookbook_params
    params.require(:lookbook).permit(:title, :photo, :rejection_message, product_ids: [])
  end
end
