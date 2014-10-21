require 'spec_helper'

feature "authenticate before_filter for unregistered users" do
  let(:u) { FactoryGirl.create(:user) }
  
  scenario 'should redirect to home page if visit signin_path' do
    visit new_user_movie_path(u)

    page.should have_selector('div', text:'You have to be logged in to do that.')
    page.should have_selector('h1', text:'Sign in')
  end
end