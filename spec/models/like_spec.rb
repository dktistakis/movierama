# == Schema Information
#
# Table name: likes
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Like do
  
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"aname", email:'jim@example.com') }
  let(:m) { FactoryGirl.create(:movie, user_id: u1.id)}
  let(:l) { FactoryGirl.create(:like, user_id: u.id, movie_id: m.id) }

  describe 'creation' do
    it 'should have a factory' do
      lambda do
        FactoryGirl.create(:like, user_id: u.id, movie_id: m.id)
      end.should change(Like, :count).by(1)
    end

    it 'should respond to its attributes' do
      l.should respond_to(:user_id)
      l.should respond_to(:movie_id)
    end
  end

  describe 'associations' do
    it 'should respond to user' do
      l.should respond_to(:user)
    end

    it 'should respond to movie' do
      l.should respond_to(:movie)
    end
  end

  describe 'validations' do
    it 'should not allow user vote same movie twice' do
      l.reload
      l2 = FactoryGirl.build(:like, user_id: u.id, movie_id: m.id)
      l2.should_not be_valid
    end

    it 'should not allow user vote his own movie' do
      l2 = FactoryGirl.build(:like, user_id: u1.id, movie_id: m.id)
      l2.should_not be_valid
    end
  end
end
