class RolesController < ApplicationController
  skip_before_action :verify_authenticity_token # keep only if testing via Thunder

  before_action :set_role, only: [:show, :edit, :update, :destroy]

  def index
    @role  = Role.new
    @roles = Role.order(:created_at)
  end

  def show; end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      redirect_to roles_path, notice: "Role created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @role.update(role_params)
      redirect_to roles_path, notice: "Role updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @role.destroy
    redirect_to roles_path, notice: "Role deleted."
  end

  private

  def set_role
    # because routes use param: :slug
    @role = Role.find_by!(slug: params[:slug])
  end

  def role_params
    params.require(:role).permit(:role, :slug)
  end
end
