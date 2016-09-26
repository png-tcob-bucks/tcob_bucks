# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

super_admin = Role.create( title: "Super Administrator", issue: true, approve: true, redeem: true, 
	admin: true, view_dept: true, view_all: true, recieve: true, issue_gold: true, inventory: true )

d = Department.create( name: "Temporary" )

j = Job.create( jobcode: '1', title: "temp")

e1 = Employee.create( IDnum: 250000123, first_name: "Bucks", last_name: "Admin", 
	job_id: super_admin.id, department_id: d.id, password: "password" )

Permission.create(job_id: j.id, role_id: super_admin.id)


