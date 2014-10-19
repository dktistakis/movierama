require 'spec_helper'

feature "Signin" do
  
  let(:u) { FactoryGirl.create(:user) }

  scenario 'sign in with valid information should login user and sign out if sign out is pressed' do
    visit signin_path

    fill_in "Name", with: u.name
    fill_in "Password", with: u.password
    click_button "Login"

    page.should have_selector('h1', text: u.name)
    page.should have_link('New Movie', href: new_user_movie_path(u))
    page.should have_link('Sign out', href: signout_path)
    page.should_not have_link('Login', href: signin_path)

    click_link "Sign out"
    page.should have_link('Login', href: signin_path)
  end

  scenario 'sign in with invalid information flash an error' do
    visit signin_path

    click_button "Login"

    page.should have_selector('h1', text: 'Sign in')
    page.should have_selector('div.flash.error', text: 'Invalid')

    click_link "MovieRama"

    page.should_not have_selector('div.flash.error')
  end

end
