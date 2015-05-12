class GroupsController < ApplicationController
  api :POST, '/groups', 'Creates group'
  param :name, String, desc: 'Group Name', required: true
  param :description, String, desc: 'Group Description'
  param :staff_ids, Array
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    group = Group.create!(group_params)
    respond_with_params(group)
  end

  api :GET, '/groups', 'Returns a collection of groups'

  def index
    groups = Group.all
    respond_with_params groups
  end

  api :GET, '/groups/:id', 'Shows group with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    group = Group.find(params[:id])
    respond_with_params group
  end

  api :PUT, '/groups/:id', 'Updates group with :id'
  param :id, :number, required: true
  param :name, String, desc: 'Group Name'
  param :description, String, desc: 'Group Description'
  param :staff_ids, Array
  error code: 404, desc: MissingRecordDetection::Messages.not_found
  error code: 422, desc: ParameterValidation::Messages.missing

  def update
    group = Group.find(params[:id])
    group.update!(group_params)
    respond_with_params(group)
  end

  api :DELETE, '/groups/:id', 'Deletes group with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    group = Group.find(params[:id])
    group.destroy
    respond_with_params(group)
  end

  private

  def group_params
    params.permit!.slice(:name, :description, :staff_ids)
  end
end
