class Mailer < ApplicationMailer

	default from: "bucks@hollywoodcasinotoledo.org"

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

	def order_notify(prize, prize_subcat, user, quantity)
		@user = user
		@prize = prize
		@prize_subcat = prize_subcat
		@quantity = quantity

		mail(to: ['HWT.Wardrobe@pngaming.com', 'paul.rowden@pngaming.com', 'amber.ulrich@pngaming.com', 'jzermen@bgsu.edu'], subject: 'New Prize Order')
	end

	def pending_buck_approval(user, buck)
		@user = user
		@buck = buck
		@employee = Employee.find_by(IDnum: buck.employee_id)
		@url = 'http://bucks.hollywoodcasinotoledo.org/bucks/pending/' + buck.number.to_s
		@approver1 = Department.find(@employee.department_id).approve1
		@approver2 = Department.find(@employee.department_id).approve2

		@approvers = Array.new
		Employee.where(status: 'Active').where(job_id: @approver1).each { |e| @approvers.push(e.email) }
		Employee.where(status: 'Active').where(job_id: @approver2).each { |e| @approvers.push(e.email) }

		mail(to: @approvers, subject: 'Buck Requiring Approval')
	end

end