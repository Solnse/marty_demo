require 'marty_demo'
require 'marty/main_auth_app'
require 'marty/permissions'
require 'marty/api_auth_view'
require 'marty_demo/config_view'

class MartyDemo::AuthApp < Marty::MainAuthApp

	def system_menu
		res = super
		res[:menu] += [:config_view]
		res
	end

	action :config_view do |a|
		a.text     = 'config'
		a.tooltip  = 'Manage system configuration'
		a.handler  = :netzke_load_component_by_action
		a.icon     = :cog
		a.disabled = !self.class.has_admin_perm?
	end

	def applications_menu
    orig = super
  end

  def self.has_scripting_perm?
  	true
  end

	component :config_view
end

AuthApp = MartyDemo::AuthApp
