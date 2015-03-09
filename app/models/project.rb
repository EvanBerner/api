# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  cc          :string(10)
#  budget      :float
#  staff_id    :string(255)
#  start_date  :date
#  end_date    :date
#  img         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  spent       :decimal(12, 2)   default(0.0)
#  status      :integer          default(0)
#  approval    :integer          default(0)
#  archived    :datetime
#
# Indexes
#
#  index_projects_on_archived    (archived)
#  index_projects_on_deleted_at  (deleted_at)
#

class Project < ActiveRecord::Base
  # Includes
  acts_as_paranoid

  # Constants
  STATES = Hash[%w(unknown ok pending warning critical).map.with_index.to_a]

  # Relationships
  has_many :project_answers
  has_many :staff_projects
  has_many :staff, through: :staff_projects
  has_many :services, foreign_key: 'project_id', class_name: 'OrderItem'
  has_many :alerts
  has_many :latest_alerts, through: :services, class_name: 'Alert'
  has_many :approvals
  has_many :approvers, through: :approvals, source: :staff
  has_one :project_detail

  accepts_nested_attributes_for :project_answers

  # Columns
  enum status: { ok: 0, warning: 1, critical: 2, unknown: 3, pending: 4 }
  enum approval: { undecided: 0, approved: 1, rejected: 2 }

  # Scopes
  scope :main_inclusions, -> { includes(:staff).includes(:project_answers).includes(:services) }
  scope :active, -> { where(archived: nil) }
  scope :archived, -> { where.not(archived: nil) }

  def order_history
    history = Order.where(id: OrderItem.where(project_id: id).select(:order_id)).map do |order|
      order_json = order.as_json
      order_json[:item_count] = order.item_count_for_project_id(id)
      order_json[:total] = order.total_per_order(order.id)
      order_json
    end
    history
  end

  def compute_current_status!
    self.status = latest_alerts.reduce('unknown') do |m, r|
      STATES[r.status.downcase] > STATES[m] ? r : m
    end.to_sym
    save!
  end

  def domain
    'companyapp1.clouddealer.com/'
  end

  def url
    'http://companyapp1.clouddealer.com'
  end

  def state
    1 == problem_count ? '1 Problem' : "#{problem_count} Problems"
  end

  def state_ok
    problem_count.zero?
  end

  def monthly_spend
    services.reduce(0) do |total, service|
      total + service.setup_price + (service.hourly_price * 750) + service.monthly_price
    end
  end

  def problem_count
    @problem_count ||= latest_alerts.not_status(:OK).count
  end

  def account_number
    785
  end

  def resources
    256
  end

  def resource_unit
    'MB'
  end

  def cpu
    8
  end

  def hdd
    '42 GB'
  end

  def ram
    '2 GB'
  end
end
