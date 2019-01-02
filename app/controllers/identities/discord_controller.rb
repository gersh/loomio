class Identities::DiscordController < Identities::BaseController
  def initialize
     @scope = ['email','identify','guilds']
  end
  private
  def oauth_host 
     "https://discordapp.com/api/v6/oauth2/authorize"
  end
  def oauth_params 
     super.merge(response_type: :code, scope: @scope.join(' '))
  end
  def identity_params
     { access_token: client.fetch_access_token(params[:code], redirect_uri, @scope.join(' ')).json['access_token'] }
  end

end
