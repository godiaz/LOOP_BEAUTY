class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome
    # WORKING
    @user = User.find(params[:user])
    @article = InsiderArticle.find(params[:article]) if params[:article].present?
    @tutorial = Tutorial.find(params[:tutorial]) if params[:tutorial].present?
    mail(to: @user.email, subject: 'Welcome to Loop Beauty')
    # mail(to: 'ifeodugbesan@hoxton-digital.com', subject: 'Welcome to Loop Beauty')
  end

  def welcome_influencer
    # WORKING
    @user = User.find(params[:user])
    mail(to: @user.email, subject: 'Welcome to Loop Beauty')
    # mail(to: 'ifeodugbesan@hoxton-digital.com', subject: 'Welcome to Loop Beauty')
  end

  def referral
    # WORKING
    @user = User.find(params[:user])
    @discount = DiscountCode.find(params[:discount])
    mail(to: @user.email, subject: 'New Referral')
    # mail(to: 'ifeodugbesan@hoxton-digital.com', subject: 'New Referral')
  end

  def content_approval
    # WORKING
    @user = params[:user]
    @content = params[:content]
    mail(to: @user.email, subject: 'The status of your content has changed')
    # mail(to: 'ifeodugbesan@hoxton-digital.com', subject: 'The status of your content has changed')
  end

  def order_confirmation
    # WORKING
    @order = Order.find(params[:order])
    @user = User.find(params[:user])
    mail(to: @user.email, subject: "Order confirmation" )
    # mail(to: 'ifeodugbesan@hoxton-digital.com', subject: "Order confirmation" )
  end

  def new_content
    # WORKING
    @influencer = params[:influencer]
    @content = params[:content]
    @rejected = params[:rejected]
    if @rejected
      mail(to: 'hello@myloopbeauty.com', subject: "#{@influencer.full_name} has edited a rejected #{@content.class.to_s}" )
      # mail(to: 'ifeodugbesan@hoxton-digital.com', subject: "#{@influencer.full_name} has edited a rejected #{@content.class.to_s}" )
    else
      mail(to: 'hello@myloopbeauty.com', subject: "#{@influencer.full_name} has shared a new #{@content.class.to_s}" )
      # mail(to: 'ifeodugbesan@hoxton-digital.com', subject: "#{@influencer.full_name} has shared a new #{@content.class.to_s}" )
    end
  end
end
