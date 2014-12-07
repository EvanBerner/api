class AlertsController < ApplicationController
  respond_to :json, :xml

  after_action :verify_authorized

  before_action :load_all_alerts, only: [:show_all]
  before_action :load_active_alerts, only: [:index, :show_active]
  before_action :load_inactive_alerts, only: [:show_inactive]
  before_action :load_alert, only: [:show, :edit, :update, :destroy]
  before_action :load_update_params, only: [:update]
  before_action :load_create_params, only: [:create]
  before_action :load_sensu_params, only: [:sensu]
  before_action :load_alert_id, only: [:create, :sensu]

  api :GET, '/alerts', 'Returns all active alerts. (Default behavior)'

  def index
    authorize Alert.new
    respond_with @alerts
  end

  api :GET, '/alerts/:id', 'Shows alert with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def show
    authorize @alert
    respond_with @alert
  end

  api :GET, '/alerts/all', 'Shows all alerts, both active and inactive.'

  def show_all
    authorize Alert.new
    respond_with @alerts
  end

  api :GET, '/alerts/active', 'Shows all active alerts. Where end_date is null or has yet to occur and start is null or has already occurred.'

  def show_active
    authorize Alert.new
    respond_with @alerts
  end

  api :GET, '/alerts/inactive', 'Shows all inactive alerts. Where end_date has already occurred or start_date has yet to occur.'

  def show_inactive
    authorize Alert.new
    respond_with @alerts
  end

  api :POST, '/alerts/sensu', 'Create new alert from Sensu response.'
  param :hostname, String, required: true, desc: 'The host of the product associated with this alert.'
  param :port, String, required: true, desc: 'The port of the product associated with this alert.'
  param :service, String, required: true, desc: 'Name of service deployed on host'
  param :status, String, required: true, desc: 'Status message associated issued with this service from Sense. <br>Current Options: OK, WARNING, CRITICAL, UNKNOWN, PENDING'
  param :message, String, required: true, desc: 'Actual message content of alert.'
  param :event, String, required: true, desc: 'TBD'
  error code: 422, desc: ParameterValidation::Messages.missing

  def sensu
    @alert = Alert.new @alert_params
    authorize @alert
    if @alert_id.nil?
      if @alert.save
        respond_with @alert
      else
        respond_with @alert.errors, status: :unprocessable_entity
      end
    else # ON DUPLICATE ALERT UPDATE
      params[:id] = @alert_id
      load_alert
      load_update_params
      update
    end
  end

  api :POST, '/alerts', 'Creates a new alert'
  param :project_id, String, required: true, desc: 'The project id issued with this new alert. <br>A 0 indicates system wide alert.'
  param :staff_id, String, required: true, desc: 'The staff id of the user who is posting this new alert. <br>0 indicates a system generated alert.'
  param :order_id, String, required: true, desc: 'The order id associated with this new alert. <br>A 0 indicates a system wide alert.'
  param :host, String, required: true, desc: 'The host this product is deployed on.'
  param :port, String, required: true, desc: 'The port this product is deployed on.'
  param :status, String, required: true, desc: 'HTTP status code issued with this alert. <br>Valid Options: OK, WARNING, CRITICAL, UNKNOWN, PENDING'
  param :message, String, required: true, desc: 'The message content of the new alert.'
  param :start_date, String, required: false, desc: 'Date this alert will begin appearing. Null indicates the alert will start appearing immediately.'
  param :end_date, String, required: false, desc: 'Date this alert should no longer be displayed after. Null indicates the alert does not expire.'
  description 'Attempts to create a new alert using the unique key of [project_id, staff_id, product_it, host, port, status]. <br>If the alert already exists, then run an on duplicate key update.'
  error code: 422, desc: ParameterValidation::Messages.missing

  def create
    @alert = Alert.new @alert_params
    authorize @alert
    if !service_alerts_exist
      save_new_alert
    else
      if last_alert_for_service.nil? || (last_alert_for_service.status != @alert.status)
        save_new_alert
      else
        params[:id] = @alert_id
        load_alert
        load_update_params
        update
      end
    end
  end

  api :PUT, '/alerts/:id', 'Updates alert with given :id'
  param :message, String, required: false, desc: 'The message content to update alert with.'
  param :start_date, String, required: false, desc: 'Date this alert will begin appearing. Null indicates the alert will start appearing immediately.'
  param :end_date, String, required: false, desc: 'Date this alert should no longer be displayed after. Null indicates the alert does not expire.'
  description 'Attempts to update an existing alert. <br>To preserve referential integrity, only the following attributes can be changed: message, start_date, end_date.'
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def update
    authorize @alert
    if @alert.update_attributes @alert_params
      @alert.touch
      respond_with @alert
    else
      respond_with @alert.errors, status: :unprocessable_entity
    end
  end

  api :DELETE, '/alerts/:id', 'Deletes alert with :id'
  param :id, :number, required: true
  error code: 404, desc: MissingRecordDetection::Messages.not_found

  def destroy
    authorize @alert
    if @alert.destroy
      respond_with @alert
    else
      respond_with @alert.errors, status: :unprocessable_entity
    end
  end

  private

  def load_create_params
    params.require :project_id
    params.require :staff_id
    params.require :order_id
    params.require :host
    params.require :port
    params.require :status
    params.require :message
    @alert_params = params.permit(:project_id, :staff_id, :order_id, :host, :port, :status, :message, :start_date, :end_date)
  end

  def load_update_params
    @alert_params = params.permit(:message, :start_date, :end_date)
  end

  def load_sensu_params
    params.require :hostname
    params[:host] = params[:hostname]
    params.require :status
    params.require :service
    params.require :message
    load_staff_and_project_id
    params[:staff_id] = @id_mapping[:staff_id]
    params[:project_id] = @id_mapping[:project_id]
    # params.require :event
    @alert_params = params.permit(:project_id, :staff_id, :order_id, :host, :port, :status, :message, :start_date, :end_date)
  end

  def load_staff_and_project_id
    @id_mapping = { staff_id: '0', project_id: '0' }
  end

  def load_all_alerts
    @alerts = Alert.all.order('id ASC')
  end

  def load_active_alerts
    @alerts = Alert.where('(start_date IS NULL OR start_date <= ?) AND (end_date IS NULL OR end_date > ?)', Time.now, Time.now).order('id ASC')
  end

  def load_inactive_alerts
    @alerts = Alert.where('end_date < ? OR start_date > ?', Time.now, Time.now).order('id ASC')
  end

  def load_alert
    @alert = Alert.find params.require(:id)
  end

  def load_alert_id
    conditions = {}
    conditions[:project_id] = @alert_params['project_id']
    conditions[:staff_id] = @alert_params['staff_id']
    conditions[:order_id] = @alert_params['order_id']
    conditions[:host] = @alert_params['host']
    conditions[:port] = @alert_params['port']
    conditions[:status] = @alert_params['status']
    result = Alert.where(conditions).order('updated_at DESC').first
    @alert_id = (result.nil? || result.id.nil?) ? nil : result.id
  end

  def service_alerts_exist
    conditions = {}
    conditions[:project_id] = @alert_params['project_id']
    conditions[:staff_id] = @alert_params['staff_id']
    conditions[:order_id] = @alert_params['order_id']
    conditions[:host] = @alert_params['host']
    conditions[:port] = @alert_params['port']
    !Alert.where(conditions).first.nil?
  end

  def last_alert_for_service
    conditions = {}
    conditions[:project_id] = @alert_params['project_id']
    conditions[:staff_id] = @alert_params['staff_id']
    conditions[:order_id] = @alert_params['order_id']
    conditions[:host] = @alert_params['host']
    conditions[:port] = @alert_params['port']
    Alert.where(conditions).order('updated_at DESC').first
  end

  def save_new_alert
    if @alert.save
      respond_with @alert
    else
      respond_with @alert.errors, status: :unprocessable_entity
    end
  end
end