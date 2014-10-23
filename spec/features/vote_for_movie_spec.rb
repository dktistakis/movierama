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

  scenario 'if logged in and other user movie' do
    m.reload
    capybara_login_user(u)

    click_link 'MovieRama'

    page.should have_content("0 likes | 0 hates")
    page.should have_selector("span", text: "0 likes")
    page.should have_selector("span", text: "0 hates")

    find('.vote-link').click

    page.should have_content("1 like | 0 hates")
    page.should have_selector("span", href: user_movie_vote_path(m.user, m.id, Vote.last.id))
    page.should have_selector("span", href: user_movie_votes_path(m.user, m, vote:false))

    click_link "Unlike"
    page.should have_content("0 likes | 0 hates")
    page.should have_selector("span", href: user_movie_votes_path(m.user, m, vote: true))
    page.should have_selector("span", href: user_movie_votes_path(m.user, m, vote:false))

    click_link "0 likes"
    click_link "0 hates"

    page.should have_content("0 likes | 1 hate")
    page.should have_selector("span", href: user_movie_vote_path(m.user, m.id, Vote.last.id))
    page.should have_selector("span", href: user_movie_votes_path(m.user, m, vote: true))

    click_link "Unhate"
    page.should have_content("0 likes | 0 hates")
    page.should have_selector("span", href: user_movie_votes_path(m.user, m, vote: true))
    page.should have_selector("span", href: user_movie_votes_path(m.user, m, vote:false))
  end

  scenario 'if logged in and same user movie' do
    m.reload
    capybara_login_user(u1)

    click_link 'MovieRama'

    page.should have_content("0 likes | 0 hates")
    page.should_not have_selector("span", href: user_movie_votes_path(m.user, m, vote: true))
    page.should_not have_selector("span", href: user_movie_votes_path(m.user, m, vote:false))
  end
end