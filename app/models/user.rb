class User < ActiveRecord::Base
  class_attribute :current_user

  def self.build_from_omniauth(auth_hash)
    user = self.new
    user.provider   = auth_hash.provider
    user.uid        = auth_hash.uid
    user.email      = auth_hash.info.email
    user.first_name = auth_hash.info.first_name
    user.last_name  = auth_hash.info.last_name
    user.full_name  = auth_hash.info.name
    user.domain     = domain_from_email(user.email)
    user
  end

  def self.find_or_create_from_omniauth(auth_hash)
    user = self.find_by_uid(auth_hash.uid)
    return user if user.present?

    user = self.build_from_omniauth(auth_hash)
    user.save!
    user
  end

  def self.domain_from_email(email)
    email.match(/@(.*)$/)[1] rescue nil
  end
end
