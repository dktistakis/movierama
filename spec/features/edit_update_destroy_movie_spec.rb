require 'spec_helper'

feature "edit, update and destroy movie" do
  let(:u) { FactoryGirl.create(:user) }
  let(:m) { FactoryGirl.create(:movie, user_id: u.id)}
  
  scenario 'successfully, should complete these actions' do
    m.reload
    capybara_login_user(u)

    click_link 'Edit'

    page.should have_content('Edit Movie')

    fill_in 'Title', with: 'Flashy Title'
    fill_in 'Description', with: 'Lorem Ipsum etc'
    click_button 'Update Movie'

    page.should have_selector('span', text: 'Flashy Title')
    page.should have_link(u.name, href: user_path(u))
    page.should have_selector('div', text: 'Lorem Ipsum etc')

    click_link 'Delete'
    page.should_not have_selector('span', text: 'Flashy Title')
    page.should have_link(u.name, href: user_path(u))
    page.should_not have_selector('div', text: 'Lorem Ipsum etc')
  end
end