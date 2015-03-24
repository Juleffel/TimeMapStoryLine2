class CharactersController < ApplicationController
  load_and_authorize_resource
  #before_action :set_character, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  respond_to :html

  def index
    if @user
      @characters = @user.characters
    else
      @characters = Character.all
    end
      
    respond_with(@characters, user_id: @user, template: 'characters/index_thumbs')
  end

  def show
    respond_with(@character, user_id: @user)
  end

  def new
    @character = Character.new(user_id: if @user then @user.id else current_user.id end)
    respond_with(@character, params: {user_id: @user})
  end

  def edit
  end

  def create
    @character = Character.new(character_params)
    if @character.save
      respond_with @character.topic
    else
      respond_with(@character, params: {user_id: @user})
    end
  end

  def update
    if @character.update(character_params)
      respond_with @character.topic
    else
      respond_with(@character, user_id: @user)
    end
  end

  def destroy
    @character.destroy
    respond_with(@character, user_id: @user)
  end

  private
    def set_character
      @character = Character.find(params[:id])
    end
    def set_user
      @user = User.find_by_id(params[:user_id])
    end

    def character_params
      params.require(:character).permit(
        :user_id, :first_name, :middle_name, :last_name, :nickname, :birth_date, :birth_place, :sex, 
        :avatar_url, :avatar_name, :copyright, :story, :summary, 
        :anecdote, :test_rp, :psychology, :appearance, :faction_id, :group_id,
        :image_url, :npc, :quote, :small_image_url)
    end
end
