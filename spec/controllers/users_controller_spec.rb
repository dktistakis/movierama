require 'spec_helper'

describe UsersController do

  let(:u) { FactoryGirl.create(:user) }

  describe "POST 'create'" do
    it 'should create a user if not signed in' do
      lambda do
        post :create, user: { name:'aname', email:'jim@examplem.com', password:'jimakos', password_confirmation:'jimakos'}
      end.should change(User, :count).by(1)
    end

    it 'should not create a user if signed in' do
      controller.current_user = u
      lambda do
        post :create, user: { name:'aname', email:'jim@examplem.com', password:'jimakos', password_confirmation:'jimakos'}
      end.should_not change(User, :count)
    end
  end
end