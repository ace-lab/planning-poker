require 'spec_helper'

describe SessionsController, type: :controller do

  let(:user) { FactoryBot.build(:user) }

  before do
    SessionsController.any_instance.stubs(:user_signed_in?).returns(true)
  end

  def valid_session
    {}
  end

  describe 'GET new' do
    it 'should redirect to root' do
      get :new, {}, valid_session
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST create' do
    let(:params) {{
      'username' => user.username,
      'password' => user.password
    }}
    
    context 'user exist' do
      before { User.stubs(:authenticate).returns(user) }

      it 'should call authenticate on User' do
        User.expects(:authenticate).with(params)
        post :create, params, valid_session
      end

      it 'should set user session' do
        post :create, params, valid_session
        expect(session[:user]).to eq({ username: user.username, token: user.token })
      end

      it 'should redirect to root' do
        post :create, params, valid_session
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before { User.stubs(:authenticate).returns(nil) }

      it 'should redirect to login path' do
        post :create, params, valid_session
        expect(response).to redirect_to login_path
      end

    end
  end

  describe 'DELETE destroy' do
    before do
      session[:user] = { 
        username: user.username,
        token:    user.token
      }
    end

    it 'should reset session' do
      delete :destroy, {}, valid_session
      expect(session).not_to have_key(:user)
    end

    it 'should redirect to login' do
      delete :destroy, {}, valid_session
      expect(response).to redirect_to login_path
    end
  end

  describe 'GET new_api_key' do
    it 'should redirect to root' do
      get :new_api_key, {}, valid_session
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST new_api_key' do
    let(:params) {{
      'username' => user.username,
      'api_key' => "abcdtestrandomchars"
    }}

    it 'should create a new user if one does not currently exist if successful' do
      post :set_api_key, params, valid_session
      expect(response).to redirect_to login_path
    end

    it 'should not create new user if not successful' do
      post :set_api_key, {'username' => "",'api_key' => ""}, valid_session
      expect(response).to redirect_to new_api_key_path
    end
  end

  # How do we even get around this??
  # describe 'GET auth/:provider/callback' do
  #   it 'should log in a user if we have the API tokens for this user' do
  #     User.stubs(:authenticate_after_oauth).returns(user)
  #     get oauth_callback_path("google_oauth"), {}, valid_session
  #     expect(response).to redirect_to root_path
  #   end

  #   it 'should not log in a user if we do not have API tokens for this user' do
  #     User.stubs(:authenticate_after_oauth).returns(nil)
  #     get :google_oauth_login, {}, valid_session
  #     expect(response).to redirect_to login_path
  #   end
  # end

end