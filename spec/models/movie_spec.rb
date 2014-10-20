require 'spec_helper'

describe Movie do

  let(:u) { FactoryGirl.create(:user)}
  let(:m) { FactoryGirl.build(:movie, user_id: u.id) }

  describe 'creation' do
    it 'should have a factory' do
      lambda do
        FactoryGirl.create(:movie, user_id: u.id)
      end.should change(Movie, :count).by(1)
    end

    it 'should respond to its attributes' do
      m.should respond_to(:title)
      m.should respond_to(:description)
      m.should respond_to(:user_id)
    end
  end

  describe 'Associations' do
    it 'should belong to user' do
      m.should respond_to(:user)
    end
  end

  describe 'Validations' do
    describe 'for title' do
      it 'should require one' do
        m.title = ''
        m.should_not be_valid
      end

      it 'should be unique' do
        m1 = FactoryGirl.create(:movie, title:'sametitle', description:"something", user_id: u.id)
        m.title = 'sametitle'
        m.should_not be_valid
      end

      it 'should reject titles that are too long' do
        m.title = 'a' * 51
        m.should_not be_valid
      end
    end

    describe 'for description' do
      it 'should require one' do
        m.description = ''
        m.should_not be_valid
      end

      it 'should reject descriptions that are too long' do
        m.description = 'a' * 301
        m.should_not be_valid
      end
    end

    describe 'for user_id' do
      it 'should have one' do
        m.user_id = nil
        m.should_not be_valid
      end

      it 'should exist' do
        m.user_id = m.user_id + 1
        m.save
        m.errors.full_messages.include?('User This user does not exist').should be_true
      end
    end
  end
end