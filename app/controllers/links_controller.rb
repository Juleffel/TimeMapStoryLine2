class LinksController < ApplicationController
  load_and_authorize_resource except: [:new]
  #before_action :set_link, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @links = Link.all
    respond_with(@links)
  end
  
  def graph
    @characters = Character.not_npc.all
    @characters_by_id = Character.not_npc.hash_by(:id)
    @modifiable_character_ids = if current_user then current_user.character_ids else [] end
    @links = Link.all
    @links_by_id = Link.hash_by(:id)
    @factions = Faction.all
    @factions_by_id = Faction.hash_by(:id)
    @link_natures = LinkNature.all
    @link_natures_by_id = LinkNature.hash_by(:id)
    @type_links_by_id = {
      1 => {
        id: 1,
        name: "All",
        link_ids: Link.all.map(&:id),
        color: "#AAA",
      }
    }
    
    @without_container = true
    respond_with(@links)
  end

  def show
    respond_with(@link)
  end

  def new
    @link = Link.new
    respond_with(@link)
  end

  def edit
  end

  def create
    @link = Link.new(link_params)
    @link.save
    if params[:from_cerebro] == "true"
      redirect_to action: "graph"
    else
      respond_with(@link)
    end
  end

  def update
    @link.update(link_params)
    if params[:from_cerebro] == "true"
      redirect_to action: "graph"
    else
      respond_with(@link)
    end
  end

  def destroy
    @link.destroy
    if params[:from_cerebro] == "true"
      redirect_to action: "graph"
    else
      respond_with(@link)
    end
  end

  private
    def set_link
      @link = Link.find(params[:id])
    end

    def link_params
      params.require(:link).permit(:from_character_id, :to_character_id, :title, :description, :force, :link_nature_id)
    end
end
