require 'rails_helper'

feature 'Project creation' do
  scenario 'staff creates a project', :js do
    staff = create(:staff)

    login_as(staff)

    visit '/project'
    find('#addNewProject span').click
    fill_in 'Name', with: 'Project Jellyfish'
    fill_in 'Icon', with: 'http://www.example.com/image.png'
    fill_in 'Budget', with: '$100,000'
    fill_in 'Start Date', with: '2015-01-01'
    fill_in 'End Date', with: '2016-01-01'
    find('a', text: 'CREATE').click

    expect(page).to have_content('Project created successfully.')
    expect(Project.last.staff_id).to eq staff.id
  end
end
