module BucksHelper
	include SessionsHelper

	def assign_buck_number
		@highest_buck = Buck.order(number: :desc).first
		return @highest_buck.number + 1
	end

	def can_employee_afford_prize(employee, prize)
		get_bucks_balance(employee) > prize.cost
	end

	def getBuckValue(reason)
		if reason.eql?("A+ Service")
			return 20
		elsif reason.eql?("Attendance")
			return 3
		elsif reason.eql?("Shift Coverage")
			return 2
		elsif reason.eql?("Customer Service")
			return 5
		elsif reason.eql?("Community Involvement")
			return 3
		else
			return 10
		end
	end

	def p_class_for_budget(used, budget)
		if used <= budget
			return 'text-success'
		elsif used > budget && used < ((budget * 0.15) + budget)
			return 'text-warning'
		else
			return 'text-danger'
		end
	end

end
