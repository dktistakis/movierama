require 'spec_helper'

feature "See user movies" do
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"othername", email:"email@gmail.com") }

  let(:m1) { FactoryGirl.create(:movie, user_id: u.id)}
  let(:m2) { FactoryGirl.create(:movie, user_id: u1.id, title:"title1")}
  let(:m3) { FactoryGirl.create(:movie, user_id: u1.id, title:"title2")}

  # goes to root path, see all movies, press a user's link, see only his movies. 
  scenario 'successfully' do
    m1.reload
    m2.reload
    m3.reload
    visit root_path

    page.should have_selector('span', text: m1.title)
    page.should have_selector('span', text: m2.title)
    page.should have_selector('span', text: m3.title)

    click_link u1.name

    page.should_not have_selector('span', text: m1.title)
    page.should have_selector('span', text: m2.title)
    page.should have_selector('span', text: m3.title)
  end
end