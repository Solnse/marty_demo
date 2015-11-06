login     = 'cedie' # your windows login name
firstname = 'Chad'
lastname  = 'Edie'
if !Marty::User.find_by_login(login)
	user = Marty::User.new
	user.login = login
	user.firstname = firstname
	user.lastname = lastname
	user.active = true
	user.save!

	Marty::Role.all.map { |role|
		ur = Marty::UserRole.new
		ur.user = user
		ur.role = role
		ur.save!
	}
end

Mcfly.whodunnit = Marty::User.find_by_login('cedie')
MartyDemo::Farm.seed
MartyDemo::Animal.seed
