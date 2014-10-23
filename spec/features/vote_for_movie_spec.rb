require 'spec_helper'

feature "Try to vote a movie" do
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"othername", email:"email@gmail.com") }
  let(:m) { FactoryGirl.create(:movie, user_id: u1.id)}

  scenario 'if not logged in, no links for voting' do
    m.reload
    visit root_path

    page.should have_content('0 likes | 0 hates')
    page.should_not have_selector("span", text: '0 hates')
  end

  scenario 'if logged in and other user movie', js: true do
    m.reload
    capybara_login_user(u)

    click_link 'MovieRama'

    page.should have_content("0 likes | 0 hates")
    page.should have_selector("span", text: "0 likes")
    page.should have_selector("span", text: "0 hates")

    find('.vote-link').click # 0 like span

    page.should have_content("1 like | 0 hates")
    page.should_not have_selector("span", text: "1 like")
    page.should have_selector("span", text: "0 hates")

    all('.vote-link')[1].click # Unlike span

    page.should have_content("0 likes | 0 hates")
    page.should have_selector("span", text: "0 likes")
    page.should have_selector("span", text: "0 hates")

    find('.vote-link').click # 0 like span
    find('.vote-link').click # 0 hate span

    page.should have_content("0 likes | 1 hate")
    page.should have_selector("span", text: "0 likes")
    page.should_not have_selector("span", text: "1 hate")

    all('.vote-link')[1].click # Unhate span
    
    page.should have_content("0 likes | 0 hates")
    page.should have_selector("span", text: "0 likes")
    page.should have_selector("span", text: "0 hates")
  end

  scenario 'if logged in and same user movie' do
    m.reload
    capybara_login_user(u1)

    click_link 'MovieRama'

    page.should have_content("0 likes | 0 hates")
    page.should_not have_selector("span", text: "0 likes")
    page.should_not have_selector("span", text: "0 hates")
  end
end