require 'marty_demo/farm_view'
require 'marty_demo/animal_view'
require 'marty_demo/crop_view'
require 'marty_demo/customer_view'
require 'marty_demo/equipment_view'

class MartyDemo::FarmManagerTabs < Netzke::Basepack::TabPanel
   def configure(c)
     super
     c.layout = :tab
     c.title  = "Farm Tab Panel"
     c.items  = [:animal_view,
                :crop_view,
                :customer_view,
                :equipment_view]
   end

  component :animal_view do |c|
    c.title                = "Animals"
    c.scope                = { farm_id: config.farm_id }
    c.strong_default_attrs = { farm_id: config.farm_id }
    c.min_width            = 700
    c.klass                = MartyDemo::AnimalView
  end

  component :crop_view do |c|
    c.title                = "Crops"
    c.scope                = { farm_id: config.farm_id }
    c.strong_default_attrs = { farm_id: config.farm_id }
    c.min_width            = 700
    c.klass                = MartyDemo::CropView
  end

  component :customer_view do |c|
    c.title                = "Customers"
    c.scope                = { farm_id: config.farm_id }
    c.strong_default_attrs = { farm_id: config.farm_id }
    c.min_width            = 700
    c.klass                = MartyDemo::CustomerView
  end

  component :equipment_view do |c|
    c.title                = "Equipments"
    c.scope                = { farm_id: config.farm_id }
    c.strong_default_attrs = { farm_id: config.farm_id }
    c.min_width            = 700
    c.klass                = MartyDemo::EquipmentView
  end
end

FarmManagerTabs = MartyDemo::FarmManagerTabs
