# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  movie_id   :integer
#  positive   :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Vote do
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"aname", email:'jim@example.com') }
  let(:m) { FactoryGirl.create(:movie, user_id: u1.id)}
  let(:l) { FactoryGirl.create(:vote, user_id: u.id, movie_id: m.id, positive: true) }
  let(:u2) { FactoryGirl.create(:user, name:"anamea", email:'jima@example.com') }
  let(:u3) { FactoryGirl.create(:user, name:"anameb", email:'jimb@example.com') }
  let(:h) { FactoryGirl.create(:vote, user_id: u2.id, movie_id: m.id) }
  let(:l1) { FactoryGirl.create(:vote, user_id: u3.id, movie_id: m.id, positive: true) }

  describe 'creation' do
    it 'should have a factory' do
      lambda do
        FactoryGirl.create(:vote, user_id: u.id, movie_id: m.id)
      end.should change(Vote, :count).by(1)
    end

    it 'should respond to its attributes' do
      l.should respond_to(:user_id)
      l.should respond_to(:movie_id)
      l.should respond_to(:positive)
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
      l2 = FactoryGirl.build(:vote, user_id: u.id, movie_id: m.id, positive: true)
      l2.should_not be_valid
    end

    it 'should not allow user vote his own movie' do
      l2 = FactoryGirl.build(:vote, user_id: u1.id, movie_id: m.id, positive: false)
      l2.should_not be_valid
    end
  end

  describe 'scopes' do
    

    it 'should filter only likes for scope: likes' do
      l.reload
      l1.reload
      h.reload
      m.votes.likes.count.should == 2
    end

    it 'should filter only hates for scope: hates' do
      l.reload
      l1.reload
      h.reload
      m.votes.hates.count.should == 1
    end
  end

  describe 'callbacks' do
    it 'should update vote_counters after save' do
      l.reload
      m.reload.likes_count.should == 1
      l1.reload
      m.reload.likes_count.should == 2
      m.hates_count.should == 0
      h.reload
      m.reload.hates_count.should == 1
    end

    it 'should update vote_counters after destroy' do
      l.reload
      l1.reload
      h.reload
      m.reload.likes_count.should == 2
      m.hates_count.should == 1
      l.destroy
      m.reload.likes_count.should == 1
      h.destroy
      m.reload.hates_count.should == 0
    end

    it 'should delete an existing like vote, if hate vote is going to create from same user for same movie.' do
      l.reload
      m.reload.votes.likes.count.should == 1
      m.votes.hates.count.should == 0
      h = FactoryGirl.create(:vote, user_id: u.id, movie_id: m.id)
      m.reload.votes.likes.count.should == 0
      m.votes.hates.count.should == 1
    end

    it 'should delete an existing hate vote, if like vote is going to create from same user for same movie.' do
      h.reload
      m.reload.votes.likes.count.should == 0
      m.votes.hates.count.should == 1
      l = FactoryGirl.create(:vote, user_id: u2.id, movie_id: m.id, positive: true)
      m.reload.votes.likes.count.should == 1
      m.votes.hates.count.should == 0
    end
  end
end
