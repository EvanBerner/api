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

describe Project do
  it { should have_many(:project_answers) }
end
