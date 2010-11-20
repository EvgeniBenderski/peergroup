class SupervisionsController < ApplicationController

  respond_to :html

  before_filter :require_parent_group, :only => [:new, :create]
  before_filter :check_current_supervision, :only => [:new, :create]
  before_filter :redirect_to_current_supervision_if_exists, :only => [:new, :create]

  def new
    @supervision = @group.supervisions.build
  end

  def create
    redirect_to supervision_step_path(@group.supervisions.create!)
  end

  def show
    @supervision = Supervision.find(params[:id])
    render :template => "solutions/index"
  end

  protected

  def check_current_supervision
    @supervision = @group.current_supervision
  end

  def redirect_to_current_supervision_if_exists
    return true if @supervision.nil? || @supervision.state == "finished"

    redirect_to supervision_step_path(@supervision)
    return false
  end
end

