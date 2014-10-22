# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  remember_token  :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'spec_helper'

describe User do
  
  let(:u) { FactoryGirl.build(:user) }

  describe 'creation' do
    it 'should have a factory' do
      lambda do
        FactoryGirl.create(:user)
      end.should change(User, :count).by(1)
    end

    it 'should respond to its attributes' do
      u.should respond_to(:name)
      u.should respond_to(:email)
      u.should respond_to(:password_digest)
      u.should respond_to(:password)
      u.should respond_to(:password_confirmation)
      u.should respond_to(:remember_token)
      u.should respond_to(:authenticate)
      u.should be_valid
    end
  end

  describe 'Validations' do

    describe 'for name' do
      it 'should require one' do
        u.name = ''
        u.should_not be_valid
      end

      it 'should have a unique one' do
        u1 = FactoryGirl.create(:user, name:'jim')
        u.name = 'JIM'
        u.should_not be_valid
      end

      it 'should reject names that are too long' do
        u.name = 'a' * 27
        u.should_not be_valid
      end

      it 'should reject names that are too short' do
        u.name = 'a' 
        u.should_not be_valid
      end
    end

    describe 'for email' do
      it 'should require one' do
        u.email = ''
        u.should_not be_valid
      end

      it 'should have a unique one' do
        u1 = FactoryGirl.create(:user, name:"aname", email:'jim@example.com')
        u.email = 'jim@example.com'.upcase
        u.should_not be_valid
      end

      it 'should reject emails in false format' do
        addresses = %w[user@foo,com user_at_foo.org example.user@foo.
        foo@bar_baz.com foo@bar+baz.com]
        addresses.each do |invalid_address|
          u.email = invalid_address
          u.should_not be_valid
        end
      end

      it 'should pass emails with correct format' do
        addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
        addresses.each do |valid_address|
          u.email = valid_address
          u.should be_valid
        end
      end
    end

    describe 'for Password' do
      it 'should not allow password to be blank' do
        u.password = u.password_confirmation = " "
        u.should_not be_valid
      end

      it 'should not allow password_confirmation to be different than password' do
        u.password_confirmation = 'somethingelse'
        u.should_not be_valid
      end

      it 'should not allow password_confirmation to be nil' do
        u.password_confirmation = 'nil'
        u.should_not be_valid
      end

      it 'should not be too short' do
        u.password = u.password_confirmation = 'a' * 5
        u.should_not be_valid
      end
    end

    describe 'for Authenticate' do
      before(:each) do
        u.save
      end
      let(:user) { User.find_by_name(u.name) }

      it 'should return value of authenticate method with valid password' do
        u.should == user.authenticate(u.password)
      end

      it 'should fail if invalid password' do
        wrong_user = user.authenticate('invalid_password')
        u.should_not == wrong_user
        wrong_user.should be_false
      end
    end

    describe 'for remember_token' do
      it 'should_not be blank' do
        u.save
        u.remember_token.should_not be_blank
      end
    end
  end

  describe 'Callbacks' do
    it 'should downcase email, before saving it' do
      u.email = "ANEMAIL@EXAMPLE.com"
      u.save
      u.email.should == "anemail@example.com"
    end

    it 'should create remember token, before saving it' do
      u.remember_token.should be_nil
      u.save
      u.remember_token.should_not be_nil
    end
  end
end
