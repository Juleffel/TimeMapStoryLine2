class RpStatusesController < ApplicationController
  load_and_authorize_resource
  #before_action :set_rp_status, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @rp_statuses = RpStatus.all
    respond_with(@rp_statuses)
  end

  def show
    respond_with(@rp_status)
  end

  def new
    @rp_status = RpStatus.new
    respond_with(@rp_status)
  end

  def edit
  end

  def create
    @rp_status = RpStatus.new(rp_status_params)
    @rp_status.save
    respond_with(@rp_status)
  end

  def update
    @rp_status.update(rp_status_params)
    respond_with(@rp_status)
  end

  def destroy
    @rp_status.destroy
    respond_with(@rp_status)
  end

  private
    def set_rp_status
      @rp_status = RpStatus.find(params[:id])
    end

    def rp_status_params
      params.require(:rp_status).permit(:name, :description, :color, :display_last, :num)
    end
end
