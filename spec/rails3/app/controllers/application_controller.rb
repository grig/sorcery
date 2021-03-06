require 'oauth'

class ApplicationController < ActionController::Base
  protect_from_forgery

  #before_filter :validate_session, :only => [:test_should_be_logged_in] if defined?(:validate_session)
  before_filter :require_login_from_http_basic, :only => [:test_http_basic_auth]
  before_filter :require_login, :only => [:test_logout, :test_should_be_logged_in,
                                          :some_action, :test_action_access_token,
                                          :test_logout_access_token]

  def index
  end

  def some_action
    render :nothing => true
  end

  def some_action_making_a_non_persisted_change_to_the_user
    current_user.username = "to_be_ignored"
    render :nothing => true
  end
  
  def test_login
    @user = login(params[:username], params[:password])
    render :text => ""
  end

  def test_auto_login
    @user = User.find(:first)
    auto_login(@user)
    @result = current_user
    render :text => ""
  end

  def test_return_to
    @user = login(params[:username], params[:password])
    redirect_back_or_to(:index, :notice => 'haha!')
  end

  def test_logout
    logout
    render :text => ""
  end

  def test_logout_with_remember
    remember_me!
    logout
    render :text => ""
  end

  def test_login_with_remember
    @user = login(params[:username], params[:password])
    remember_me!

    render :text => ""
  end

  def test_login_with_remember_in_login
    @user = login(params[:username], params[:password], params[:remember])

    render :text => ""
  end

  def test_login_from_cookie
    @user = current_user
    render :text => ""
  end

  def test_not_authenticated_action
    render :text => "test_not_authenticated_action"
  end

  def test_should_be_logged_in
    render :text => ""
  end

  def test_http_basic_auth
    render :text => "HTTP Basic Auth"
  end

  def login_at_test
    login_at(:twitter)
  end

  def login_at_test2
    login_at(:facebook)
  end

  def login_at_test3
    login_at(:github)
  end

  def login_at_test4
    login_at(:google)
  end

  def login_at_test5
    login_at(:liveid)
  end

  def test_login_from
    if @user = login_from(:twitter)
      redirect_to "bla", :notice => "Success!"
    else
      redirect_to "blu", :alert => "Failed!"
    end
  end

  def test_login_from2
    if @user = login_from(:facebook)
      redirect_to "bla", :notice => "Success!"
    else
      redirect_to "blu", :alert => "Failed!"
    end
  end

  def test_login_from3
    if @user = login_from(:github)
      redirect_to "bla", :notice => "Success!"
    else
      redirect_to "blu", :alert => "Failed!"
    end
  end

  def test_login_from4
    if @user = login_from(:google)
      redirect_to "bla", :notice => "Success!"
    else
      redirect_to "blu", :alert => "Failed!"
    end
  end

  def test_login_from5
    if @user = login_from(:liveid)
      redirect_to "bla", :notice => "Success!"
    else
      redirect_to "blu", :alert => "Failed!"
    end
  end

  def test_login_from_client_side4
    @user = login_from_client_side(params[:provider], params[:access_token_hash])
    if @api_access_token
      render :json => { access_token: @api_access_token.token }
    else
      head :unauthorized
    end
  end

  def test_create_from_provider
    provider = params[:provider]
    login_from(provider)
    if @user = create_from(provider)
      redirect_to "bla", :notice => "Success!"
    else
      redirect_to "blu", :alert => "Failed!"
    end
  end

  ##
  # Access Token

  # Login, returns access_token on successful login or unauthorized
  def test_login_access_token
    @user = login(params[:username], params[:password])
    respond_to do |format|
      format.json do
        if @api_access_token
          render :json => { access_token: @api_access_token.token }
        else
          head :unauthorized
        end
      end
    end
  end

  # Action, unauthorized if access_token is invalid (default)
  def test_action_access_token
    respond_to do |format|
      format.json do
        if @api_access_token
          head :ok
        end
      end
    end
  end

  # Logout
  def test_logout_access_token
    logout
    head :ok
  end

  protected



end
