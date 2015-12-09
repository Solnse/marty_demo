require 'marty/panel'

class MartyDemo::ConfigView < Marty::Grid
  has_marty_permissions \
  create: :admin,
  read:   :admin,
  update: :admin,
  delete: :admin

  def configure(c)
    super

    c.title   = "Config"
    c.model   = "MartyDemo::Config"
    c.columns = [:key, :value]

    c.blank_text = 'xxx'
    c.enable_extended_search = false
    c.data_store.sorters     = {property: :key, direction: 'ASC'}
  end

  column :key do |c|
    c.flex = 1
  end

  column :value do |c|
    c.flex = 3
  end
end

ConfigView = MartyDemo::ConfigView
