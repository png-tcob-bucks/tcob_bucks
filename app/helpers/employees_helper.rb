module EmployeesHelper

	def get_profile_picture(user_id)
		@picture = Dir.glob("app/assets/images/profile_photos/*#{user_id}.jpg") 
		@picture = @picture.first.split('/')[4]
		return 'profile_photos/'+ @picture.to_s
	end

end
