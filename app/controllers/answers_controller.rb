class AnswersController < ApplicationController
  load_and_authorize_resource
  #before_action :set_answer, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @answers = Answer.all
    respond_with(@answers)
  end

  def show
    respond_with(@answer)
  end

  def new
    @topic = Topic.find_by_id(params[:topic_id])
    if @topic
      @answer = Answer.new(topic_id: @topic.id)
      respond_with(@answer)
    else
      redirect_to categories_url
    end
  end

  def edit
  end

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    if can? :update, @answer
      @answer.save
    end
    if @answer.topic
      redirect_to topic_url(@answer.topic)
    else
      redirect_to categories_url
    end
  end

  def update
    @answer.update(answer_params)
    if @answer.topic
      redirect_to topic_url(@answer.topic)
    else
      redirect_to categories_url
    end
  end

  def destroy
    topic = @answer.topic
    if topic
      @answer.destroy
      redirect_to topic_url(topic)
    else
      @answer.destroy
      redirect_to categories_url
    end
  end

  private
    def set_answer
      @answer = Answer.find(params[:id])
    end

    def answer_params
      params.require(:answer).permit(:title, :content, :topic_id, :character_id)
    end
end
