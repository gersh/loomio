class Identities::Discord < Identities::Base
  include Identities::WithClient
  set_identity_type :discord

  def apply_user_info(payload)
    self.uid   ||= payload['id']
    self.name  ||= payload['username']
    self.email ||= payload['email']
    self.logo  ||= payload['avatar']
    guilds = client.fetch_guilds.json
    if not guilds.each{|g|g[:id]==Rails.application.secrets[:allowed_guild].to_s}.any?
       throw "Bad server"
    end
  end

end
