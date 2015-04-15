require 'marty/permissions'
require 'marty_demo/auth_app'
require 'netzke/basepack/grid'
require 'netzke/basepack/fields'

class MartyDemo::ComponentsController < Marty::ComponentsController
	def home
		render inline: "<%= netzke :'auth_app' %>", layout: true
	end
end
