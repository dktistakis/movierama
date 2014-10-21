require 'spec_helper'

feature "Order movies" do
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"othername", email:"email@gmail.com") }
  let(:u2) { FactoryGirl.create(:user, name:"othername1", email:"email1@gmail.com") }

  let(:m1) { FactoryGirl.create(:movie, user_id: u.id)}
  let(:m2) { FactoryGirl.create(:movie, user_id: u1.id, title:"title1")}
  let(:m3) { FactoryGirl.create(:movie, user_id: u1.id, title:"title2")}

  let(:l1) { FactoryGirl.create(:like, user_id: u.id, movie_id: m2.id )}
  let(:l2) { FactoryGirl.create(:like, user_id: u.id, movie_id: m3.id )}
  let(:l3) { FactoryGirl.create(:like, user_id: u2.id, movie_id: m2.id )}

  let(:h1) { FactoryGirl.create(:hate, user_id: u1.id, movie_id: m1.id )}
  let(:h2) { FactoryGirl.create(:hate, user_id: u2.id, movie_id: m1.id )}
  let(:h3) { FactoryGirl.create(:hate, user_id: u.id, movie_id: m3.id )}

  scenario 'by date' do
    m1.reload
    m2.reload
    m3.reload

    visit root_path

    m3.title.should appear_before(m2.title)
    m2.title.should appear_before(m1.title)
  end

  scenario 'by likes' do
    m1.reload
    m2.reload
    m3.reload
    l1.reload
    l2.reload
    l3.reload

    visit root_path

    click_link 'Likes'

    m2.title.should appear_before(m3.title)
    m3.title.should appear_before(m1.title)
  end

  scenario 'by hates' do
    m1.reload
    m2.reload
    m3.reload
    h1.reload
    h2.reload
    h3.reload

    visit root_path

    click_link 'Hates'

    m1.title.should appear_before(m3.title)
    m3.title.should appear_before(m2.title)
  end
end