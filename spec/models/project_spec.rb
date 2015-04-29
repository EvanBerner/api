# == Schema Information
#
# Table name: projects
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :text
#  cc          :string(10)
#  img         :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  deleted_at  :datetime
#  status      :integer          default(0)
#  approval    :integer          default(0)
#  archived    :datetime
#  spent       :decimal(12, 2)   default(0.0)
#  budget      :decimal(12, 2)   default(0.0)
#  start_date  :datetime
#  end_date    :datetime
#
# Indexes
#
#  index_projects_on_archived    (archived)
#  index_projects_on_deleted_at  (deleted_at)
#

describe Project do
  it { should have_many(:project_answers) }
end

describe 'Project.compute_current_status!' do
  it "sets the project's status to the alert with the highest priority" do
    low_priority_alert = create(:alert, status: :ok)
    high_priority_alert = create(:alert, status: :critical)
    project = create(
      :project,
      services: [
        create(:order_item, latest_alert: low_priority_alert),
        create(:order_item, latest_alert: high_priority_alert)
      ]
    )

    project.compute_current_status!

    expect(project.status).to eq(high_priority_alert.status)
  end

  it 'returns "unknown" if the project has no recent alerts' do
    project = create(:project)

    project.compute_current_status!

    expect(project.status).to eq('unknown')
  end
end

describe 'Project.monthly_spend' do
  it 'returns total monthly spend' do
    project = create(:project)
    create_list(:order_item, 2, project: project, monthly_price: 1.0)

    expect(project.monthly_spend).to be_a Float
    expect(project.monthly_spend).to eq 2.0
  end
end
