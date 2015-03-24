class LinkNaturesController < ApplicationController
  load_and_authorize_resource
  #before_action :set_link_nature, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @link_natures = LinkNature.all
    respond_with(@link_natures)
  end

  def show
    respond_with(@link_nature)
  end

  def new
    @link_nature = LinkNature.new
    respond_with(@link_nature)
  end

  def edit
  end

  def create
    @link_nature = LinkNature.new(link_nature_params)
    @link_nature.save
    respond_with(@link_nature)
  end

  def update
    @link_nature.update(link_nature_params)
    respond_with(@link_nature)
  end

  def destroy
    @link_nature.destroy
    respond_with(@link_nature)
  end

  private
    def set_link_nature
      @link_nature = LinkNature.find(params[:id])
    end

    def link_nature_params
      params.require(:link_nature).permit(:name, :description, :color)
    end
end
