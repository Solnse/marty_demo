require 'marty_demo'
require 'marty/main_auth_app'
require 'marty/permissions'
require 'marty/api_auth_view'
require 'marty_demo/config_view'
require 'marty_demo/farm_manager'

class MartyDemo::AuthApp < Marty::MainAuthApp

	def system_menu
		res = super
		res[:menu] += [:config_view]
		res
	end

  def data_menus
    basic = [
      {
        text: 'examples',
        menu: [:farm_manager,
               :farm_view,
               :animal_view]
      }
    ]
  end

	action :config_view do |a|
		a.text     = 'config'
		a.tooltip  = 'Manage system configuration'
		a.handler  = :netzke_load_component_by_action
		a.icon     = :cog
		a.disabled = !self.class.has_admin_perm?
	end

  action :farm_manager do |a|
    a.text     = 'Farm Manager'
    a.tooltip  = 'Farm Manager'
    a.handler  = :netzke_load_component_by_action
  end

  action :farm_view do |a|
    a.text     = 'Farms'
    a.tooltip  = 'Farms'
    a.handler  = :netzke_load_component_by_action
  end

  action :animal_view do |a|
    a.text     = 'Animals'
    a.tooltip  = 'Animals'
    a.handler  = :netzke_load_component_by_action
  end

	def applications_menu
    orig = super
  end

  def self.has_scripting_perm?
  	true
  end

	component :config_view
  component :farm_manager
  component :farm_view
  component :animal_view
end

AuthApp = MartyDemo::AuthApp
