require 'spec_helper'

describe HatesController do
  let(:u) { FactoryGirl.create(:user) }
  let(:u1) { FactoryGirl.create(:user, name:"othername", email:"email@gmail.com") }
  let(:m) { FactoryGirl.create(:movie, user_id: u.id)}

  before(:each) do
    request.env["HTTP_REFERER"] = '/'
  end

  describe "POST 'create'" do
    it 'should not create Hate if unregistered user' do
      lambda do
        post :create, user_id: u.id, movie_id: m.id
      end.should_not change(Hate, :count)
    end

    it 'should not create Hate if own movie' do
      controller.current_user = u
      lambda do
        post :create, user_id: u.id, movie_id: m.id
      end.should_not change(Hate, :count)
    end

    it 'should create Hate if signedin user' do
      controller.current_user = u1
      lambda do
        post :create, user_id: u1.id, movie_id: m.id
      end.should change(Hate, :count).by(1)
    end
  end

  describe "DELETE 'destroy'" do
    
    let(:h) { FactoryGirl.create(:hate, movie_id: m.id, user_id: u1.id)}

    it 'should not destroy Hate if unregistered user' do
      h.reload
      lambda do
        delete :destroy, user_id: u1.id, movie_id: m.id, id: h.id
      end.should_not change(Hate, :count)
    end

    it 'should destroy Hate if signedin user' do
      controller.current_user = u1
      h.reload
      lambda do
        delete :destroy, user_id: u.id, movie_id: m.id, id: h.id
      end.should change(Hate, :count).by(-1)
    end
  end
end