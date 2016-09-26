class Mailer < ApplicationMailer

	default from: "bucks@hollywoodcasinotoledo.org"

	def pending_buck_approval(user, buck)
		@user = user
		@buck = buck
		@employee = Employee.find_by(IDnum: buck.employee_id)
		@url = 'http://bucks.hollywoodcasinotoledo.org/bucks/pending/' + buck.number.to_s
		@directors = Employee.where(department_id: @employee.department_id).where(status: 'Active')
		@directors = @directors.select { |d| d.can_approve_bucks }
		@directors.map! { |d| d.email }

		mail(to: @directors, subject: 'Buck Requiring Approval')
	end

	def mail_feedback(message)
		@from = @current_user
		@message = message
		@roles = Role.where(feedback: true)
		@roles = @roles.map { |r| r.id }
		@jobcodes = Permission.where(role_id: @roles)
		@jobcodes = @jobcodes.map { |f| f.job_id }
		@recipients = Array.new
		@jobcodes.each do |f|
			Employee.where(job_id: f).where(status: "Active").each do |e|
				@recipients.push(e.email)
			end
		end

		mail(to: @recipients, subject: 'Bucks Feedback')
	end

end