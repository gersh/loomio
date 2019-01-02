class Identities::Discord < Identities::Base
  include Identities::WithClient
  set_identity_type :discord

  def apply_user_info(payload)
    self.uid   ||= payload['id']
    self.name  ||= payload['username']
    self.email ||= payload['email']
    self.logo  ||= payload['avatar']
  end
end
