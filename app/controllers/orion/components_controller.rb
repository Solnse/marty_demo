require 'marty/permissions'
require 'orion/auth_app'
require 'netzke/basepack/grid'
require 'netzke/basepack/fields'

class Orion::ComponentsController < Marty::ComponentsController
	def home
		render inline: "<%= netzke :'auth_app' %>", layout: true
	end
end
