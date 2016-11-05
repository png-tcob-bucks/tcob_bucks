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

		mail(to: @recipients, subject: 'Feedback: #{@from.full_name}')
	end

	def mail_issue(message, url)
		@from = @current_user
		@message = message
		@url = url
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

		mail(to: @recipients, subject: 'Issue: #{@from.full_name}')
	end

	def notify_employee(buck, user)
		@user = user
		@buck = buck
		@issuer = Employee.find(buck.assignedBy)

		mail(to: user.email, subject: 'Buck Awarded!')
	end

	def notify_issuer(buck, issuer, employee, decision, reason)
		@buck = buck
		@issuer = issuer
		@employee - employee
		@decision = decision
		@reason = reason

		mail(to: @issuer.email, subject: 'Pending Buck Status')
	end

	def opt_in
		@user = Employee.find(params[:id])
		@user.update_attribute(:email, true)
		flash[:title] = 'Success'
		flash[:notice] = 'You will now receive email notifications from the bucks program!'
		redirect_to controller: :employee, action: :show, id: @current_user
	end

	def opt_out
		@user = Employee.find(params[:id])
		@user.update_attribute(:email, false)
		flash[:title] = 'Success'
		flash[:notice] = 'You will no longer receive email notifications from the bucks program.'
		redirect_to controller: :employee, action: :show, id: @current_user
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