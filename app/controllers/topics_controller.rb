class TopicsController < ApplicationController
  load_and_authorize_resource
  #before_action :set_topic, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @topics = Topic.all
    respond_with(@topics)
  end

  def show
    @answers = @topic.answers.includes({character: [:user, :faction, :group]})
    @without_container = true
    respond_with(@topic)
  end

  def new
    @category = Category.find_by_id(params[:category_id])
    @spacetime_position = SpacetimePosition.find_by_id(params[:spacetime_position_id])
    @topic = Topic.new
    if @category
      @topic.category = @category
    end
    if @spacetime_position
      @topic.spacetime_position = @spacetime_position
    end
    respond_with(@topic)
  end

  def edit
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.user_id = current_user.id
    @topic.save
    respond_with(@topic)
  end

  def update
    @topic.update(topic_params)
    respond_with(@topic)
  end

  def destroy
    if @topic.category
      @topic.destroy
      redirect_to category_url(@topic.category)
    elsif @topic.spacetime_position
      @topic.destroy
      #TODO redirect maps
      respond_with(@topic)
    else
      @topic.destroy
      redirect_to action: "index"
    end
  end

  private
    def set_topic
      @topic = Topic.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:spacetime_position_id, :category_id, :title, :subtitle, :summary, :weather, :image_url)
    end
end
