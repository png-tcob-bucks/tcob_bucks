class Job < ActiveRecord::Base
	has_many :permissions
	has_many :roles, through: :permissions

	self.primary_key = 'jobcode'
end
