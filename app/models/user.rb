class User < ApplicationRecord
	def self.find_or_create_from_auth_hash(auth)
		where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
			user.provider = auth.provider
			user.uid = auth.uid
			user.first_name = auth.info.first_name
			user.last_name = auth.info.last_name
			user.email = auth.info.email
			user.picture = auth.info.image
      user.display_name = auth.extra.raw_info.displayName 
      user.job_title = auth.extra.raw_info.jobTitle 
			user.save!
		end
	end
end 
