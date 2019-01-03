class Clients::Discord < Clients::Base

  def fetch_access_token(code, uri, scope)
    post "api/v6/oauth2/token", params: { code: code, redirect_uri: uri, grant_type: :authorization_code, scope: scope }
  end

  def fetch_user_info
    get "api/v6/users/@me"
  end

  def fetch_guilds
    get "api/v6/users/@me/guilds"
  end

  def scope
    %w(email profile).freeze
  end

  private
  def default_params
    { client_id: @key, client_secret: @secret }.delete_if { |k,v| v.nil? }
  end

  def default_headers
    h = { 'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8' }
    if not @token.nil?
       h = h.merge('Authorization' => 'Bearer ' + @token)
    end
    h
  end

  def token_name
    :oauth_token
  end

  def default_host
    "https://discordapp.com".freeze
  end
end
