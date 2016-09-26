class Department < ActiveRecord::Base
	has_many :employees

	validates_numericality_of :budget, :message => 'Must be a number'

	def get_budget_overall
		self.budget
	end

	def get_budget_per_employee
		@employees = Employee.where(department_id: self.id)
		@employees = @employees.select { |e| e.can_issue_bucks }
		self.budget / @employees.count if @employees.count > 0
	end

	def get_budget_used(month, year)
		used = 0
		@employees = Employee.where(department_id: self.id)
		@employees.each do |e|
			used += e.get_personal_budget_used(month, year)
		end
		return used
	end

	def get_budget_used_percent(month, year)
		((self.get_budget_used(month, year).to_f / self.get_budget_overall.to_f) * 100).round(2)
	end

#  def get_individual_budget
#    self.get_budget_overall / Employee.where(department_id: self.id).where(role_id: [2,3,4,5,6]).count
#  end

  def get_remaining_from_budget
		@department.budget - get_bucks_issued
	end

	def get_property_budget_total
		Department.all.sum(:budget)
	end

	def get_property_budget_used
		used = 0
		Department.all.each do |d|
			used += d.get_budget_used
		end
		return used
	end

	def get_propety_budget_total_used_percent
		((self.get_budget_used.to_f / get_property_budget_used) * 100).round(2)
	end

end
