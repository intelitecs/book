class OAuthUser < ActiveRecord::Base
  attr_reader :provider, :user
  belongs_to :user

  def initialize ( creds, user = nil)
    @auth       = creds
    @user       = user
    @provider   = @auth.provider
    @policy     = "#{@provider}_policy".classify.constantize.new(@auth)
  end

  def login_or_create
    logged_in? ? create_new_account : (login || create_new_account)
  end

  def logged_in?
    @user.present?
  end

  def login
    @account = Account.where(@auth.slice("provider","uid")).first
    if @account.present?
      refresh_tokens
      @user = @account.user
      @policy.refresh_callback(@account)
    else
      false
    end
  end

  def refresh_tokens
    @account.update_attributes(oauth_token:  @policy.oauth_token,
                               oauth_secret: @policy.oauth_secret,
                               oauth_expires: @policy.oauth_expires)
  end

  def create_new_account
    create_new_user if @user.nil?

    unless account_already_exists?
      @account = @user.accounts.create!(
          provider:       @provider,
          uid:            @policy.uid,
          oauth_token:    @policy.oauth_token,
          oauth_secret:   @policy.oauth_secret,
          oauth_expires:  @policy.oauth_expires,
          username:       @policy.username
      )
      @policy.create_callback(@account)
    end
  end

  def account_already_exists?
    @user.accounts.exists?(provider: @provider, uid: @policy.uid)
  end

  def create_new_user
    @user = User.create!(
        username: "#{@policy.first_name} #{@policy.last_name}",
        email:    @policy.email,
        # picture: image
    )
  end

  def image
    image = open(URI.parse(@policy.image_url), ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE)
    def image.original_filename; base_uri_path.split('/').last end
    image
  end
end
