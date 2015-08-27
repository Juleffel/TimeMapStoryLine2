class SpacetimePositionsController < ApplicationController
  load_and_authorize_resource
  #before_action :set_spacetime_position, only: [:show, :edit, :update, :destroy]

  respond_to :html, :json

  def index
    @spacetime_positions = SpacetimePosition.all
    respond_with(@spacetime_positions)
  end

  def show
    respond_with(@spacetime_position)
  end

  def new
    @spacetime_position = SpacetimePosition.new
    respond_with(@spacetime_position)
  end

  def edit
  end

  def create
    @spacetime_position = SpacetimePosition.new(spacetime_position_params.merge({user_id: current_user.id}))
    @spacetime_position.save
    respond_with(@spacetime_position)
  end

  def update
    @spacetime_position.update(spacetime_position_params.merge({user_id: current_user.id}))
    respond_with(@spacetime_position)
  end

  def destroy
    @spacetime_position.destroy
    respond_with(@spacetime_position)
  end

  private
    def set_spacetime_position
      @spacetime_position = SpacetimePosition.find(params[:id])
    end

    def spacetime_position_params
      params.require(:spacetime_position).permit(
        :longitude, :latitude, :title, :subtitle, :resume, :weather, 
        :begin_at, :end_at, character_ids: [])
    end
end
