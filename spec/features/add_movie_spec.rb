require 'spec_helper'

feature "Add Movie" do
  let(:u) { FactoryGirl.create(:user) }
  
  scenario 'successfully should show this movie in user_show and movies_index' do
    visit signin_path

    fill_in 'Name', with: u.name
    fill_in 'Password', with: u.password
    click_button 'Login'

    click_link 'New Movie'
    fill_in 'Title', with: 'Flashy Title'
    fill_in 'Description', with: 'Lorem Ipsum etc'
    click_button 'Create Movie'

    page.should have_selector('span', text: 'Flashy Title')
    page.should have_link(u.name, href: user_path(u))
    page.should have_selector('div', text: 'Lorem Ipsum etc')

    click_link 'MovieRama'
    page.should have_selector('span', text: 'Flashy Title')
    page.should have_link(u.name, href: user_path(u))
    page.should have_selector('div', text: 'Lorem Ipsum etc')
  end
end