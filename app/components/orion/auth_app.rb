require 'orion'
require 'marty/main_auth_app'
require 'marty/permissions'
require 'marty/api_auth_view'
require 'orion/config_view'

class Orion::AuthApp < Marty::MainAuthApp

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

  def ident_menu
    '<span style="color:#B32D15; font-size:150%; font-weight:bold;">' +
      'Orion</span>'
  end

	component :config_view
end

AuthApp = Orion::AuthApp
