require 'spec_helper'

feature "Require_not_logged_in before_filter for signed_in users" do
  let(:u) { FactoryGirl.create(:user) }

  before(:each) do
    capybara_login_user(u)
  end
  
  scenario 'should redirect to home page if visit signin_path' do
    visit signin_path

    page.should have_selector('h1', text:'All the Movies')
  end

  scenario 'should redirect to home page if visit signup_path' do
    visit signup_path

    page.should have_selector('h1', text:'All the Movies')
  end
end