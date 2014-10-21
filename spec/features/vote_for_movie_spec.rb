require 'spec_helper'

feature "Try to vote a movie" do
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"othername", email:"email@gmail.com") }
  let(:m) { FactoryGirl.create(:movie, user_id: u1.id)}
  let(:m1) { FactoryGirl.create(:movie, user_id: u.id)}
  let(:l) { FactoryGirl.create(:like, user_id: u.id, movie_id: m.id) }

  scenario 'if not logged in, no links for voting' do
    m.reload
    visit root_path

    page.should have_content('0 likes | 0 hates')
    page.should_not have_link("#{m.likes.count} likes", href: user_movie_likes_path(m.user, m))
  end

  scenario 'if logged in and other user movie' do
    m.reload
    capybara_login_user(u)

    click_link 'MovieRama'

    page.should have_content("0 likes | 0 hates")
    page.should have_link("0 likes", href: user_movie_likes_path(m.user, m))
    page.should have_link("0 hates", href: user_movie_hates_path(m.user, m))

    click_link "0 likes"

    page.should have_content("1 like | 0 hates")
    page.should have_link("Unlike", href: user_movie_like_path(m.user, m.id, Like.last.id))
    page.should have_link("0 hates", href: user_movie_hates_path(m.user, m))

    click_link "Unlike"
    page.should have_content("0 likes | 0 hates")
    page.should have_link("0 likes", href: user_movie_likes_path(m.user, m))
    page.should have_link("0 hates", href: user_movie_hates_path(m.user, m))

    click_link "0 likes"
    click_link "0 hates"

    page.should have_content("0 likes | 1 hate")
    page.should have_link("Unhate", href: user_movie_hate_path(m.user, m.id, Hate.last.id))
    page.should have_link("0 likes", href: user_movie_likes_path(m.user, m))

    click_link "Unhate"
    page.should have_content("0 likes | 0 hates")
    page.should have_link("0 likes", href: user_movie_likes_path(m.user, m))
    page.should have_link("0 hates", href: user_movie_hates_path(m.user, m))
  end

  scenario 'if logged in and same user movie' do
    m.reload
    capybara_login_user(u1)

    click_link 'MovieRama'

    page.should have_content("0 likes | 0 hates")
    page.should_not have_link("0 likes", href: user_movie_likes_path(m.user, m))
    page.should_not have_link("0 hates", href: user_movie_hates_path(m.user, m))
  end
end