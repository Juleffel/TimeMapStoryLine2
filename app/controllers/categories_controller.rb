class CategoriesController < ApplicationController
  load_and_authorize_resource
  #before_action :set_category, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @categories = Category.roots.includes({categories: :categories})
    if params[:mod] == "true" and can? :manage, Category
      @mod = true
    end
    respond_with(@categories)
  end

  def show
    if params[:mod] == "true" and can? :manage, Category
      @mod = true
    end
    @categories = @category.categories.includes(:categories)
    @topics = Topic.order(@category.topics.includes(:user, {answers: {character: :faction}}))
    @special_topics = Topic.order(@category.special_topics)
    respond_with(@category)
  end

  def new
    @subcategory = Category.find_by_id(params[:category_id])
    @category = Category.new(category: @subcategory)
    respond_with(@category)
  end

  def edit
  end

  def create
    @category = Category.new(category_params)
    @category.save
    redirect_to action: "index", mod: true
  end

  def update
    @category.update(category_params)
    redirect_to action: "index", mod: true
  end

  def destroy
    @category.destroy
    redirect_to action: "index", mod: true
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:category_id, :title, :description, :image_url, :permission_level, :num, :special)
    end
end
