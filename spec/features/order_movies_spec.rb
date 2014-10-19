require 'spec_helper'

feature "Order movies" do
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"othername", email:"email@gmail.com") }

  let(:m1) { FactoryGirl.create(:movie, user_id: u.id, likes_count: 1, hates_count: 4)}
  let(:m2) { FactoryGirl.create(:movie, user_id: u1.id, title:"title1", likes_count: 5, hates_count: 6)}
  let(:m3) { FactoryGirl.create(:movie, user_id: u1.id, title:"title2", likes_count: 3, hates_count: 3)}

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
    visit root_path

    click_link 'Likes'

    m2.title.should appear_before(m3.title)
    m3.title.should appear_before(m1.title)
  end

  scenario 'by likes' do
    m1.reload
    m2.reload
    m3.reload
    visit root_path

    click_link 'Hates'

    m2.title.should appear_before(m1.title)
    m1.title.should appear_before(m3.title)
  end
end