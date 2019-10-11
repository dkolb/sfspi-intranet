class User < ApplicationRecord
  def self.find_from_auth_hash(auth)
    where(provider: auth.provider, uid: auth.uid).first
  end

	def self.create_from_auth_hash(auth)
    User.new.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.email = auth.info.email
			user.picture = auth.info.image
      if auth.provider == 'google_oauth2'
        user.display_name = auth.info.name
      else
        user.display_name = auth.extra.raw_info.displayName 
      end
      user.job_title = auth.extra.raw_info.jobTitle 
			user.save!
		end
	end

  def update_from_auth_hash(auth)
    self.provider = auth.provider
    self.uid = auth.uid
    self.first_name = auth.info.first_name
    self.last_name = auth.info.last_name
    self.email = auth.info.email
    self.picture = auth.info.image
    if auth.provider == 'google_oauth2'
      self.display_name = auth.info.name
    else
      self.display_name = auth.extra.raw_info.displayName 
    end
    self.job_title = auth.extra.raw_info.jobTitle 
    save!
  end
end 
