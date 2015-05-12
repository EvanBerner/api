class MembershipsController < ApplicationController
  after_action :verify_authorized

  api :POST, '/projects/:project_id/groups/:group_id', 'Add a group membership to a project'
  param :project_id, :number, 'ID of Project to add group membership to', required: true
  param :group_id, :number, 'ID of Group to associate with the project', required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def create
    membership = Membership.new(membership_params)
    authorize(membership)
    membership.save
    head :ok
  end

  api :PUT, '/projects/:project_id/groups/:group_id', 'Update the role of a membership'
  param :project_id, :number, 'ID of Project to add group membership to', required: true
  param :group_id, :number, 'ID of Group to associate with the project', required: true
  param :role_id, :number, 'ID of Role', required: true

  def update
    membership = Membership.find_by!(membership_params)
    authorize(membership)
    membership.update!(role: Role.find(params[:role_id]))
    head :ok
  end

  api :DELETE, '/projects/:project_id/groups/:group_id', 'Remove a group from a project'
  param :project_id, :number, required: true
  param :group_id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    membership = Membership.find_by!(membership_params)
    authorize(membership)
    membership.destroy
    head :ok
  end

  private

  def membership_params
    params.permit!.slice(:group_id, :project_id)
  end
end
