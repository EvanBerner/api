require 'rails_helper'

feature 'Add group to project', js: true do
  scenario 'give group access to a project by adding it on the project edit page' do
    group = create(:group, role: nil)
    role = create(:role)
    project = create(:project)
    staff = create(:staff, :admin, groups: [group])
    login_as staff

    visit "/project/#{project.id}"
    find('#group_search input').click
    within('#group_search_dropdown') do
      first('div', text: group.name).click
    end

    within('#groups-list') do
      expect(page).to have_content(group.name)
      expect(page).to have_selector("#group-#{group.id}")
    end

    within("#group-#{group.id}-role") do
      find('.selectize-input').click
      first('*', text: role.name).click
    end

    expect(Group.last.role).to eq role
  end
end
