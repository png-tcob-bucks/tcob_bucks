class Role < ActiveRecord::Base
	has_many :permissions
	has_many :jobs, through: :permissions
end
