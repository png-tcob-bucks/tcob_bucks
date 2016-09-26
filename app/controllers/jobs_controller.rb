class JobsController < ApplicationController
	include SessionsHelper

	before_filter :authenticate_user_logged_in

	def import
		@jobs_imported = CSV.read("#{Rails.root}/public/jobs_import.csv")
		Job.delete_all
		@jobs_imported.shift # Get rid of header contents
		@jobs_imported.each do |j|
			if !Job.exists?(jobcode: j[0])
				job_params = { 
					:jobcode => j[0],
					:title => j[1]
				}
				Job.new(job_params).save
			end
		end
		redirect_to action: 'index'
	end

	def index
		@jobs = Job.all
	end

end
