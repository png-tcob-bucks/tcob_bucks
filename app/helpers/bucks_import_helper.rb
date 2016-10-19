module BucksImportHelper

	require 'date'

	COLUMN_BUCK_NUMBER = 0
	COLUMN_BUCK_EMPLOYEE_ID = 2
	COLUMN_BUCK_DATE = 4
	COLUMN_BUCK_ISSUER_ID = 6
	COLUMN_BUCK_REASON_SHORT = 8
	COLUMN_BUCK_VALUE = 9
	COLUMN_BUCK_REASON_LONG = 8

	def import_bucks
		@bucks_array = CSV.read("#{Rails.root}/public/FINALBUCKS.csv")

		@bucks_array.each do |e|
			if !Buck.exists?(number: e[COLUMN_BUCK_NUMBER]) && Employee.exists?(IDnum: e[COLUMN_BUCK_EMPLOYEE_ID])
				date = DateTime.strptime(e[COLUMN_BUCK_DATE], '%m/%d/%Y').strftime('%d/%m/%Y')
				buck_params = { 
					:number => e[COLUMN_BUCK_NUMBER],
					:employee_id => e[COLUMN_BUCK_EMPLOYEE_ID],
					:value => e[COLUMN_BUCK_VALUE],
					:status => 'Active',
					:assignedBy => e[COLUMN_BUCK_ISSUER_ID],
					:department_id => extract_department(e[COLUMN_BUCK_EMPLOYEE_ID]),
					:reason_short => e[COLUMN_BUCK_REASON_SHORT],
					:reason_long => e[COLUMN_BUCK_REASON_LONG],
					:expires => date.to_datetime.advance(:years => +1),
					:approved_at => date.to_datetime
				}
				Buck.new(buck_params).save
			end 
		end
	end

	def extract_department(employeeID)
		Employee.find(employeeID).department_id
	end

end
