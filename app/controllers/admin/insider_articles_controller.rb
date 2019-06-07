class Admin::InsiderArticlesController < ApplicationController
  before_action :set_insider_article, only: [:publish, :unpublish, :destroy, :edit, :update]

  def new
    @insider_article = InsiderArticle.new
  end

  def create
    @insider_article = InsiderArticle.new(insider_article_params)
    @insider_article.user = current_user
    if @insider_article.save
      redirect_to insider_article_path(@insider_article)
    else
      render :new
    end
  end

  def edit
  end

  def destroy
    @insider_article.destroy
    redirect_to insider_articles_path
  end

  def publish
    @insider_article.published = true
    @insider_article.save
    redirect_to insider_article_path(@insider_article)
  end

  def unpublish
    @insider_article.published = false
    @insider_article.save
    redirect_to insider_article_path(@insider_article)
  end

  private

  def insider_article_params
    params.require(:insider_article).permit(
      :category,
      :title,
      :text1,
      :text2,
      :text3,
      :text4,
      :cover_photo,
      :photo1,
      :photo2,
      :photo3,
      :cover_alt_text,
      :photo1_alt_text,
      :photo2_alt_text,
      :photo3_alt_text,
      :by,
      :published
    )
  end

  def set_insider_article
    @insider_article = InsiderArticle.find(params[:id])
    authorize [:admin, @insider_article]
  end

end
