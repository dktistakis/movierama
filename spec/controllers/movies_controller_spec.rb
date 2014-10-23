require 'spec_helper'

describe MoviesController do
  render_views

  let(:u) { FactoryGirl.create(:user) }
  let(:m) { FactoryGirl.create(:movie, user_id: u.id)}
  let(:u1) { FactoryGirl.create(:user, name:"aname", email:'jim@example.com') }

  describe "POST 'create'" do
    it 'should not create movie if unregistered user' do
      lambda do
        post :create, movie: { title: 'a title', description: 'a description'}, user_id: u.id
      end.should_not change(Movie, :count)
    end

    it 'should create movie if signed in' do
      controller.current_user = u
      lambda do
        post :create, movie: { title: 'a title', description: 'a description'}, user_id: u.id
      end.should change(Movie, :count).by(1)
    end
  end

  describe "PUT 'update'" do

    it 'should update attributes of movie if signed in' do
      controller.current_user = u
      m.reload
      put :update, movie: { title: 'another_title', description: 'another description'}, user_id: u.id, id: m.id
      m.reload.title.should == 'another_title'
      m.description.should == 'another description'
    end

    it 'should raise RoutingError if other user to update another user movie' do
      controller.current_user = u1
      m.reload
      lambda do
        put :update, movie: { title: 'another_title', description: 'another description'}, user_id: u.id, id: m.id
      end.should raise_error( ActionController::RoutingError )
    end

    it 'should raise RoutingError if not signed in' do
      m.reload
      lambda do
        put :update, movie: { title: 'another_title', description: 'another description'}, user_id: u.id, id: m.id
      end.should raise_error( ActionController::RoutingError )
    end
  end

  describe "DESTROY 'delete'" do
    it "should delete movie if it's its user" do
      controller.current_user = u
      m.reload
      lambda do
        delete :destroy, user_id: u.id, id: m.id
      end.should change(Movie, :count).by(-1)
    end

    it 'should raise RoutingError if other user tries to destroy another user movie' do
      controller.current_user = u1
      m.reload
      lambda do
        delete :destroy, user_id: u.id, id: m.id
      end.should raise_error( ActionController::RoutingError )
    end

    it 'should raise RoutingError if not signed in' do
      m.reload
      lambda do
        delete :destroy, user_id: u.id, id: m.id
      end.should raise_error( ActionController::RoutingError )
    end
  end
end