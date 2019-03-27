require 'spec_helper'

describe User, type: :model do
  let(:username)  { Forgery(:internet).email_address }
  let(:username2)  { Forgery(:internet).email_address }
  let(:password)  { 'password' }
  let(:token) {'COMPLETELY_RANDOM_API_KEY'}

  let(:params) {{
    username: username,
    password: password
  }}

  let(:user) { FactoryBot.create(:user) }

  describe '.class' do

    context '#authenticate' do
      before { User.stubs(:create).returns(user) }
      
      it 'should return nil' do
        expect(User.authenticate({})).to be_nil
      end

      it 'should call find_by on User' do
        User.expects(:where).with(
          username: params[:username]
        ).returns([ user ])
        user.stubs(:authenticated?)

        User.authenticate(params)
      end

      it 'should return user' do
        expect(User.authenticate(params)).to eq user
      end

      it 'should create user' do
        user.delete
        User.expects(:create).with(params)
        User.authenticate(params)
      end
    end

    context '#create' do
      let(:fake_response) { mock }
      before do
        JSON.stubs(:parse).with(fake_response).returns({'api_token' => user.token})
        RestClient::Request.stubs(:execute).returns(fake_response)
        User.stubs(:salted).returns(user.salt)
      end

      after  { User.create(params) }

      it 'should call token on PivotalTracker::Client' do
        RestClient::Request.expects(:execute).returns(fake_response)
      end

      it 'should call salted' do
        User.expects(:salted).with(params[:username])
      end

      it 'should call new' do
        User.expects(:new).with(params.merge(token: user.token)).returns(user)
      end

      it 'should call save' do
        User.any_instance.expects(:save)
      end
    end

    context '#set_new_api_key' do
      it 'creates new user if one does not exist' do
        num_users_before = User.all.size
        User.set_new_api_key({'username': username2, 'api_key': token})
        assert_equal num_users_before + 1, User.all.size
      end

      it 'updates old user if new API key passed in' do
        one_mock = mock
        JSON.stubs(:parse).with(one_mock).returns({'api_token' => user.token})
        RestClient::Request.stubs(:execute).returns(one_mock)
        User.stubs(:salted).returns(user.salt)
        User.create(params)

        num_users_before = User.all.size
        User.set_new_api_key({username: username, api_key: token})
        assert_equal num_users_before, User.all.size
      end
    end

    context '#authenticate_after_oauth' do
      it 'returns nil if user token not found' do
        # User doesn't exist
        assert_equal User.authenticate_after_oauth(username2), nil

        # User exists but doesn't have non-empty token set
        one_mock = mock
        JSON.stubs(:parse).with(one_mock).returns({'api_token' => ""})
        RestClient::Request.stubs(:execute).returns(one_mock)
        User.stubs(:salted).returns(user.salt)
        User.create(params)

        assert_equal User.authenticate_after_oauth(username), nil
      end

      it 'returns the user if user token is found' do
        one_mock = mock
        JSON.stubs(:parse).with(one_mock).returns({'api_token' => user.token})
        RestClient::Request.stubs(:execute).returns(one_mock)
        User.stubs(:salted).returns(user.salt)
        u = User.create(params)

        assert_equal User.authenticate_after_oauth(username), u
      end
    end
  end
end