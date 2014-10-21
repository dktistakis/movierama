# == Schema Information
#
# Table name: hates
#
#  id         :integer          not null, primary key
#  movie_id   :integer
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Hate do
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"aname", email:'jim@example.com') }
  let(:m) { FactoryGirl.create(:movie, user_id: u1.id)}
  let(:h) { FactoryGirl.create(:hate, user_id: u.id, movie_id: m.id) }

  describe 'creation' do
    it 'should have a factory' do
      lambda do
        FactoryGirl.create(:hate, user_id: u.id, movie_id: m.id)
      end.should change(Hate, :count).by(1)
    end

    it 'should respond to its attributes' do
      h.should respond_to(:user_id)
      h.should respond_to(:movie_id)
    end
  end

  describe 'associations' do
    it 'should respond to user' do
      h.should respond_to(:user)
    end

    it 'should respond to movie' do
      h.should respond_to(:movie)
    end
  end

  describe 'validations' do
    it 'should not allow user hate same movie twice' do
      h.reload
      h2 = FactoryGirl.build(:hate, user_id: u.id, movie_id: m.id)
      h2.should_not be_valid
    end

    it 'should not allow user hate his own movie' do
      h2 = FactoryGirl.build(:hate, user_id: u1.id, movie_id: m.id)
      h2.should_not be_valid
    end
  end
end
