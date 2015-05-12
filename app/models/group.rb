# == Schema Information
#
# Table name: groups
#
#  id          :integer          not null, primary key
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string
#  description :text
#

class Group < ActiveRecord::Base
  has_and_belongs_to_many :staff
  has_many :memberships
  has_many :projects, through: :memberships
end
