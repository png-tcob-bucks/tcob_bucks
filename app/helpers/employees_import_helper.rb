module EmployeesImportHelper

	COLUMN_SSN = 0
	COLUMN_EMPLOYEE_NUMBER = 1
	COLUMN_EMPLOYEE_NAME = 2
	COLUMN_JOB_CODE = 4
	COLUMN_JOB_TITLE = 5
	COLUMN_DEPARTMENT = 6
	COLUMN_STATUS = 9
	COLUMN_EMAIL = 23

	def import_employees
		@employees_array = CSV.read("#{Rails.root}/public/TOGV_CABINET.CSV")
		@employees_array.shift # Get rid of header contents

		@employees_array.each do |e|

			if !Job.exists?(jobcode: e[COLUMN_JOB_CODE])
				job_params = { 
					:jobcode => e[COLUMN_JOB_CODE],
					:title => e[COLUMN_JOB_TITLE]
				}
				Job.new(job_params).save
			end

			if !Department.exists?(name: e[COLUMN_DEPARTMENT])
				Department.new(:name => e[COLUMN_DEPARTMENT]).save
			end

			if !Employee.exists?(IDnum: e[COLUMN_EMPLOYEE_NUMBER])
				employee_params = { 
					:IDnum => e[COLUMN_EMPLOYEE_NUMBER],
					:first_name => extract_first_name(e[COLUMN_EMPLOYEE_NAME]),
					:last_name => extract_last_name(e[COLUMN_EMPLOYEE_NAME]),
					:job_id => e[COLUMN_JOB_CODE],
					:department_id => extract_department_id(e[COLUMN_DEPARTMENT]),
					:password => extract_last_4_ssn(e[COLUMN_SSN]),
					:email => e[COLUMN_EMAIL],
					:status => e[COLUMN_STATUS]
				}
				Employee.new(employee_params).save
			end
		end
	end

	def extract_first_name(name)
		if name.last == '.'
			name.split(", ")[1][0..-4].split.map(&:capitalize).join(' ')
		else
			name.split(", ")[1].split.map(&:capitalize).join(' ')
		end
	end

	def extract_last_name(name)
		name.split(",")[0].split.map(&:capitalize).join(' ')
	end

	def extract_department_id(department_name)
		Department.where(name: department_name).first.id
	end

	def extract_last_4_ssn(ssn)
		ssn.last(4)
	end

end
