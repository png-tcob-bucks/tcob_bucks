class Employee < ActiveRecord::Base

  has_many :favorites
  has_many :bucks
  has_many :prizes, through: :favorites

  require 'csv'

  # attr_accessor :remember_token

	self.primary_key = 'IDnum'

	belongs_to :department
	has_many :bucks
  has_one :job_code

  scope :top10_aplus, -> {
    select("employees.id, employees.IDnum, count(bucks.id) AS bucks_count").
    joins(:bucks).
    where("bucks.reason_short='A+ Service'").
    group("employees.id").
    order("bucks_count DESC").
    limit(5) }

  scope :top10_attendance, -> {
    select("employees.id, employees.IDnum, count(bucks.id) AS bucks_count").
    joins(:bucks).
    where("bucks.reason_short='Attendance'").
    group("employees.id").
    order("bucks_count DESC").
    limit(5) }

  scope :top10_community, -> {
    select("employees.id, employees.IDnum, count(bucks.id) AS bucks_count").
    joins(:bucks).
    where("bucks.reason_short='Community Involvement'").
    group("employees.id").
    order("bucks_count DESC").
    limit(5) }

  scope :top10_service, -> {
    select("employees.id, employees.IDnum, count(bucks.id) AS bucks_count").
    joins(:bucks).
    where("bucks.reason_short='Customer Service'").
    group("employees.id").
    order("bucks_count DESC").
    limit(5) }

  scope :top10_shift, -> {
    select("employees.id, employees.IDnum, count(bucks.id) AS bucks_count").
    joins(:bucks).
    where("bucks.reason_short='Shift Coverage'").
    group("employees.id").
    order("bucks_count DESC").
    limit(5) }

  scope :top10_other, -> {
    select("employees.id, employees.IDnum, count(bucks.id) AS bucks_count").
    joins(:bucks).
    where("bucks.reason_short='Other'").
    group("employees.id").
    order("bucks_count DESC").
    limit(5) }

  has_secure_password
  validates :password_digest, presence: true, length: { minimum: 6 }

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      Employee.create! row.to_hash
    end
  end

  def self.search(id, first, last)
    if id || first || last
      where(status: "Active").
      where('IDnum LIKE ? 
        AND first_name LIKE ? 
        AND last_name LIKE ?', "%#{id}%", "%#{first}%", "%#{last}%")
    else
      Employee.all.limit(20)
    end
  end

  def self.search_all(id, first, last)
    if id || first || last
      where('IDnum LIKE ? 
        AND first_name LIKE ? 
        AND last_name LIKE ?', "%#{id}%", "%#{first}%", "%#{last}%")
    else
      Employee.all.limit(20)
    end
  end

  def self.search_preshow(id, first, last)
    if id || first || last
      where(status: "Active").
      where('IDnum LIKE ? 
        AND first_name LIKE ? 
        AND last_name LIKE ?', "%#{id}%", "%#{first}%", "%#{last}%")
    else
      self.all
    end
  end

  def self.sort_by_earned_month
    Employee.all.sort_by(&:get_bucks_earned_month)
  end

  # If implementing Remember Me
  # def Employee.new_token
  #   SecureRandom.urlsafe_base64
  # end

  # def remember
  #   self.remember_token = Employee.new_token
  #   update_attribute(:remember_digest, Employee.digest(remember_token))
  # end

  # REQUESTS FOR ALL SPECIFIC PERMISIONS ON ROLES

  def full_name
    self.first_name + " " + self.last_name
  end

  def has_general_access
    return true if Job.find(self.job_id).roles.exists?(access: true)
  end

  def has_admin_access
    return true if Job.find(self.job_id).roles.exists?(admin: true)
  end

  def can_issue_bucks
    return true if Job.find(self.job_id).roles.exists?(issue: true) && self.status == "Active"
  end

  def can_issue_gold_bucks
    return true if Job.find(self.job_id).roles.exists?(issue_gold: true)
  end

  def can_manage_inventory
    return true if Job.find(self.job_id).roles.exists?(inventory: true)
  end

  def can_approve_bucks
    return Department.exists?(approve1: self.job_id) || Department.exists?(approve2: self.job_id) || self.has_admin_access
  end

  def can_redeem_bucks
    return true if Job.find(self.job_id).roles.exists?(redeem: true)
  end

  def can_view_dept
    return true if Job.find(self.job_id).roles.exists?(view_dept: true)
  end

  def can_view_all
    return true if Job.find(self.job_id).roles.exists?(view_all: true)
  end

  def can_recieve_bucks
    return true if Job.find(self.job_id).roles.exists?(recieve: true)
  end

  def can_receive_feedback
    return true if Job.find(self.job_id).roles.exists?(feedback: true)
  end

  # SPECIFIC ACTIONS USING PERMISSIONS
  def is_same_department(employee)
    return self.department_id == employee.department_id
  end

  def is_in_department(department)
    return self.department_id == department.id
  end

  def can_view_employee(employee)
    return (self.can_view_dept && self.is_same_department(employee)) || self.can_view_all
  end

  def can_view_buck(buck)
    return self.id == buck.employee_id || (self.can_view_dept && self.is_same_department(Employee.find(buck.employee_id))) || self.can_view_all
  end

  def get_bucks_balance
    return Buck.where(employee_id: self.id).where(status: ['Active', 'Partial']).sum(:value)
  end

  def get_bucks_earned_month
    return BuckLog.where(recieved_id: self.id).where('extract(month from created_at) = ?', Time.now.strftime("%m")).where(status_after: ['Active']).sum(:value_after)
  end

  def get_bucks_earned_year
    return BuckLog.where(recieved_id: self.id).where('extract(year from created_at) = ?', Time.now.strftime("%Y")).where(status_after: ['Active']).sum(:value_after)
  end

  def get_pending_bucks
    jobcode = self.job_id
    approve_for = Department.where('approve1 = \'' + jobcode + '\' OR approve2 = \'' + jobcode + '\'')
    bucks = Array.new
    approve_for.each { |d| Buck.where(department_id: d.id).where(status: 'Pending').each { |b| bucks.push(b) }}
    return bucks
  end

  def get_personal_budget_used(month, year)
    Buck.where('extract(month from approved_at) = ? AND extract(year from approved_at) = ?', "#{month}", "#{year}").where(assignedBy: self.id).count
  end

  def get_personal_budget_used_percent(month, year)
    department = Department.find(self.department_id)
    return ((get_personal_budget_used(month, year).to_f / department.get_budget_per_employee.to_f) * 100).round(2) if get_personal_budget_used(month, year).to_f > 0
    return 0
  end

  def get_department_budget_used_percent(month, year)
    department = Department.find(self.department_id)
    return ((get_personal_budget_used(month, year).to_f / department.get_budget_overall.to_f) * 100).round(2) if get_personal_budget_used(month, year).to_f > 0
    return 0
  end

  def get_department_overall_used_percent(month, year)
    department = Department.find(self.department_id)
    ((get_personal_budget_used(month, year).to_f / department.get_budget_used.to_f) * 100).round(2)
  end

  def is_over_budget?(month, year)
    self.get_personal_budget_used(month, year) > Department.find(self.department_id).get_budget_per_employee
  end

end
