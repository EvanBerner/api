require 'rails_helper'

feature 'Stack wizard' do
  scenario 'user runs the Wizard', :js do
    staff = create(:staff, :admin)
    login_as(staff)
    questions = create_pair(:wizard_question, :with_answers)
    visit '/wizard'
    # expected_tags = []

    questions.each do |question|
      expect(page).to have_content(question.text)

      # answer = question.answers.first
      # expected_tags = update_tags(expected_tags, answer)

      select question.wizard_answers.first.text
      click_on 'Next Question'
    end
    click_on 'Done now.'

    #  expect(current_path).to include(expected_tags.join("/"))
  end

  # def update_tags(tags, answer)
  #   tags += answer.tags_to_add.split(", ")
  #   tags -= answer.tags_to_remove.split(", ")
  #   tags
  # end
end
