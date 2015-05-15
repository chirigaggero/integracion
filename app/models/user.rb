class User < ActiveRecord::Base
	has_secure_password

 	def token_expired?
    	DateTime.now >= self.token_expires_at
  	end

  	def generate_token
    	begin
      		self.token = SecureRandom.hex
    	end while self.class.exists?(token: token)
    	self.set_expiration
    	self.save
    	return self.token
  	end

  	def set_expiration
    	self.token_expires_at = DateTime.now+1 # expira en un dia
  	end
end
