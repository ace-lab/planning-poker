class SessionsController < ApplicationController

  def new
    redirect_to :root if user_signed_in?
  end

  def create
    user = User.authenticate(session_params)

    if user
      session[:user] = {
        username: user.username,
        token:    user.token,
      }
    
      redirect_to :root, notice: t('flashes.sessions.success')
    else
      redirect_to :login, alert: t('flashes.sessions.failed')
    end
  end

  def destroy
    reset_session
    redirect_to :login, notice: t('flashes.sessions.destroy')
  end

  def new_api_key
    redirect_to :root if user_signed_in?
  end

  def set_api_key
    # Take email and API key, set new user
    # Then redirect to login with success flash noting that API key saved
    if params[:api_key].blank? or params[:username].blank?
      redirect_to :new_api_key, alert: t('flashes.sessions.token_not_set')
    else
      User.set_new_api_key(params)
      redirect_to :login, notice: t('flashes.sessions.token_set')
    end
  end

  private
  
  def session_params
    params.permit(
      :username, :password
    )
  end
end