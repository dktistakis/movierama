require 'spec_helper'

describe MoviesController do
  render_views

  let(:u) { FactoryGirl.create(:user) }

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
end