class Permission < ActiveRecord::Base
	belongs_to :job
	belongs_to :role

end
