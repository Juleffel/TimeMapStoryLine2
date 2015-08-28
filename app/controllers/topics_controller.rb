class TopicsController < ApplicationController
  load_and_authorize_resource
  #before_action :set_topic, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    topic_includes = [:user, {answers: {character: :faction}}]
    @nb_days = 2
    if params["nb_days"]
      begin
        @nb_days = Integer(params["nb_days"])
      rescue ArgumentError
        p("Wrong number:", params["nb_days"])
      end
    end
    @rpg_topics = Topic.filter_recent(Topic.order(Topic.rpg_topics.includes(topic_includes)), @nb_days)
    @flood_topics = Topic.filter_recent(Topic.order(Topic.flood_topics.includes(topic_includes)), @nb_days)
    @other_topics = Topic.filter_recent(Topic.order(Topic.other_topics.includes(topic_includes)), @nb_days)
    @auto_topics = Topic.filter_recent(Topic.order(Topic.auto_topics(topic_includes)), @nb_days)
    @topics = @rpg_topics+@flood_topics+@auto_topics+@other_topics
    respond_with(@topics)
  end

  def show
    @answers = @topic.answers.includes({character: [:user, :faction, :group]})
    @category = @topic._category
    @category_role = @category.special_role if @category
    @character = @topic.special_character
    @links = (@character.to_links if @category_role == :links)
    @rp_topics = (@character.character_rp_topics if @category_role == :rps)
    @user_rp_topics = (@character.user_rp_topics if @category_role == :rps)
    @character = @topic.special_character
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
      @topic.title = @spacetime_position.title
      @topic.subtitle = @spacetime_position.resume
      @categories = Category.roots.rpg.all
    else
      @categories = Category.roots.all
    end
    respond_with(@topic)
  end

  def edit
    if @topic.spacetime_position
      @categories = Category.roots.rpg.all
    else
      @categories = Category.roots.all
    end
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
      params.require(:topic).permit(:spacetime_position_id, :category_id, :title, :subtitle, 
        :summary, :weather, :image_url, :rp_status_id)
    end
end
