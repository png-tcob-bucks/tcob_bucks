module BucksHelper
	include SessionsHelper

	def getBuckValue(reason)
		if reason.eql?("A+ Service")
			return 20
		elsif reason.eql?("Attendance")
			return 2
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

	def can_employee_afford_prize(employee, prize)
		get_bucks_balance(employee) > prize.cost
	end

	def p_class_for_budget(used, budget)
		if used <= budget
			return 'text-green'
		elsif used > budget && used < ((budget * 0.15) + budget)
			return 'text-yellow'
		else
			return 'text-red'
		end
	end

end
