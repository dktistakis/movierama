require 'spec_helper'

feature "Signup" do
  
  scenario 'sign up with valid information should create user' do
    visit signup_path

    fill_in "Name", with: "Example User"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "foobar"
    fill_in "Confirmation", with: "foobar"
    expect { click_button :signup_submit }.to change(User, :count).by(1)
  end

  scenario 'sign up with invalid information not create user' do
    visit signup_path

    fill_in "Name", with: "Example User"
    fill_in "Email", with: "userexample.com"
    fill_in "Password", with: "foobar"
    fill_in "Confirmation", with: "foobari"
    expect { click_button :signup_submit }.not_to change(User, :count)
  end

end