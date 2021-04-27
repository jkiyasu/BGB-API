class ResourcesController < ApplicationController
  before_action :set_resource, only: [:show, :update, :destroy]

  # GET /resources
  def index
    @resources = Resource.all
    if params[:sort_dist].present? || session[:sort_dist].present?
      redirect_to distance_resource_path
    end

    if params[:sort_topic].present? || session[:sort_topic].present?
      redirect_to topic_resource_path
    end

    render json: @resources

  end


  def distance
    @dist = params[:sort_dist] || session[:sort_dist]
    if params[:sort_dist] != session[:sort_dist]
      session[:sort_dist] = @dist
    end

    @resources = Resource.where("distance <= ?", @dist).order(:distance)
    render json: @resources
  end


  def topic
    @top = params[:sort_topic] || session[:sort_topic]
    if params[:sort_topic] != session[:sort_topic]
      session[:sort_topic] = @top
    end

    @connectors = Connector.where("topic == ?", @top)
    @resources = @connectors.resources
    render json: @resources
  end


  # GET /resources/1
  def show
    render json: @resource
  end

  # POST /resources
  def create
    @resource = Resource.new(resource_params)

    if @resource.save
      render json: @resource, status: :created, location: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /resources/1
  def update
    if @resource.update(resource_params)
      render json: @resource
    else
      render json: @resource.errors, status: :unprocessable_entity
    end
  end

  # DELETE /resources/1
  def destroy
    @resource.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_resource
      @resource = Resource.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def resource_params
      params.require(:resource).permit(:resource, :phone, :description, :hours, :distance)
    end
end
