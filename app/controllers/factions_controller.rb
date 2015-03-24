class FactionsController < ApplicationController
  load_and_authorize_resource
  #before_action :set_faction, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @factions = Faction.all
    respond_with(@factions)
  end

  def show
    respond_with(@faction)
  end

  def new
    @faction = Faction.new
    respond_with(@faction)
  end

  def edit
  end

  def create
    @faction = Faction.new(faction_params)
    @faction.save
    respond_with(@faction)
  end

  def update
    @faction.update(faction_params)
    respond_with(@faction)
  end

  def destroy
    @faction.destroy
    respond_with(@faction)
  end

  private
    def set_faction
      @faction = Faction.find(params[:id])
    end

    def faction_params
      params.require(:faction).permit(:name, :description, :color)
    end
end
