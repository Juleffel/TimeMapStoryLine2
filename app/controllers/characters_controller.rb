class CharactersController < ApplicationController
  load_and_authorize_resource
  #before_action :set_character, only: [:show, :edit, :update, :destroy]
  before_action :set_user

  respond_to :html#, :json

  def index
    if @user
      @characters = @user.characters.not_npc
    else
      @characters = Character.not_npc.all
    end
      
    respond_with(@characters, user_id: @user, template: 'characters/index_thumbs')
  end
  
  def map
    @without_container = true
    respond_to do |format|
      format.html
      format.json do
        @characters_updated_at = Character.last_update
        if params[:all] == "true"
          @spacetime_positions_by_id = SpacetimePosition.hash_by(:id)
          @characters_by_id = Character.hash_by(:id)
          @topics_by_id = Topic.where("spacetime_position_id > 0").hash_by(:id)
          #@nodes_by_begin_at = Node.hash_by(:begin_at)
          render :json => {
            :characters_updated_at => @characters_updated_at,
            :characters_by_id => @characters_by_id,
            :spacetime_positions_by_id => @spacetime_positions_by_id,
            :topics_by_id => @topics_by_id,
            :topics_url => topics_path,
          }
        else
          render :json => {
            :characters_updated_at => @characters_updated_at,
          }
        end
      end
    end
  end
  
  def destroy_presence
    presence = Presence.where(character_id: params[:id], spacetime_position_id: params[:spacetime_position_id]).first
    respond_to do |format|
      if can? :destroy, presence
        presence.destroy
        format.json { render json: true, status: :ok }
      else
        format.json { render json: "Not authorized", status: :unauthorized }
      end
    end
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
    if not current_user.admin?
      @character.group_id = Group.where(default_group: true).first.id
      @character.npc = false
    end
    if @character.npc
      @character.group_id = Group.specials(:npc).first.id
    end
    if @character.save
      respond_with @character.topic
    else
      respond_with(@character, params: {user_id: @user})
    end
  end

  def update
    ch_params = character_params
    if not @character.npc
      ch_params["npc"] = false
    end
    if not current_user.admin? and  @character.group.no_modif
      ch_params["group_id"] = @character.group_id.to_s
    end
    if @character.update(ch_params)
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
        :image_url, :npc, :quote, :small_image_url,
        :shortline1, :shortline2)
    end
end
