class Buck < ActiveRecord::Base
	belongs_to :employee
	self.primary_key = 'number'

	def self.search(number, recipient, issuer)
    if number || recipient || issuer
      where('number LIKE ? 
        AND employee_id LIKE ? 
        AND assignedBy LIKE ?', "%#{number}%", "%#{recipient}%", "%#{issuer}%")
    else
      Buck.all.limit(20)
    end
  end

  def self.search_dept(dept, month, year)
  	month = Date::MONTHNAMES.index(month) 
    if !month.blank? && !year.blank?
    	where('department_id = ? ', "#{dept}")
    	.where('extract(year  from approved_at) = ?
        AND extract(month from approved_at) = ?', "#{year}", "#{month}")
      # .where('extract(month from approved_at) = ?', Time.now.strftime("%m"))
    elsif !month.blank? 
    	where('department_id = ? ', "#{dept}")
    	.where('extract(month from approved_at) = ?', "#{month}")
      # .where('extract(month from approved_at) = ?', Time.now.strftime("%m"))
    elsif !year.blank?
    	where('department_id = ? ', "#{dept}")
    	.where('extract(year  from approved_at) = ?', "#{year}")
    end
  end

  def this_month?
		this_month = Time.now.strftime("%m")
		this_year = Time.now.strftime("%Y")

		self.approved_at.strftime("%m") == this_month && self.approved_at.strftime("%Y") == this_year
	end

	def needs_approval(current_user, employee)
		return (current_user.department_id != employee.department_id) || self.reason_short == "Other"
	end


  def this_month?
    this_month = Time.now.strftime("%m")
    this_year = Time.now.strftime("%Y")

    self.approved_at.strftime("%m") == this_month && self.approved_at.strftime("%Y") == this_year
  end

  def needs_approval(current_user, employee)
    return self.reason_short == "Other"
  end

  def self.sort_by_name
    self.sort_by(&:get_employee_name).reverse
  end

  def get_employee_name
    Employee.find(self.employee_id).first_name
  end

end
