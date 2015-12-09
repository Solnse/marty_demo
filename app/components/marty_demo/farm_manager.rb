require 'marty_demo/farm_view'
require 'marty_demo/animal_view'
require 'marty_demo/crop_view'
require 'marty_demo/equipment_view'
require 'marty_demo/customer_view'

class MartyDemo::FarmManager < Marty::Panel
  include Marty::Extras::Layout

  js_configure do |c|
    c.init_component = <<-JS
      function(){
        var me = this;
        me.callParent();

        var farm = me.netzkeGetComponent('farm_view');
        var farm_view = farm.getView();

        farm.getSelectionModel().on('selectionchange', function(selModel) {
          var has_sel = selModel.hasSelection();
          var rec_id =
            has_sel ? farm_view.getSelectionModel().selected.first().getId() :
              null;

          for (var key in farm.actions) {
            if (key.substring(0, 2) == "do") {
              farm.actions[key].setDisabled(!has_sel);
            }
          }

          me.selectFarm({farm_id: rec_id});
          // TODO: dynamically load only the selected tab.
          me.reloadAnimalView();
          me.reloadCropView();
          me.reloadEquipmentView();
          me.reloadCustomerView();
        });
      }
    JS

    c.reload_farm_view = <<-JS
      function() {
        var me = this;
        var farm_component = me.netzkeGetComponent('farm_view');
        var farm_view = farm_component.getView();
        farm_view.getStore().load();
      }
    JS

    c.reload_animal_view = <<-JS
      function() {
        var me = this;
        var animal_component = me.netzkeGetComponent('animal_view');
        var animal_view = animal_component.getView();
        animal_view.getStore().load();
      }
    JS

    c.reload_crop_view = <<-JS
      function() {
        var me = this;
        var crop_component = me.netzkeGetComponent('crop_view');
        var crop_view = crop_component.getView();
        crop_view.getStore().load();
      }
    JS

    c.reload_equipment_view = <<-JS
      function() {
        var me = this;
        var equipment_component = me.netzkeGetComponent('equipment_view');
        var equipment_view = equipment_component.getView();
        equipment_view.getStore().load();
      }
    JS

    c.reload_customer_view = <<-JS
      function () {
        var me = this;
        var customer_component = me.netzkeGetComponent('customer_view');
        var customer_view = customer_component.getView();
        customer_view.getStore().load();
      }
    JS
  end

  def configure(c)
    super

    c.title  = "Farm Details"
    c.header = false
    c.items  =
      [
       :farm_view,
       {
         xtype: "tabpanel",
         active_tab: 0,
         region: :center,
         split: true,
         items: [
                 :animal_view,
                 :crop_view,
                 :equipment_view,
                 :customer_view
                ],
       },
      ]
  end

  def manager_farm_id
    root_sess[:manager_farm_id]
  end

  endpoint :select_farm do |params, this|
    farm_id = params[:farm_id]

    if farm_id
      farm = MartyDemo::Farm.find_by_id(farm_id)
      return this.netzke_feedback "Can't find farm id #{farm_id}" unless farm
    end

    root_sess[:manager_farm_id] = farm_id
  end

  component :farm_view do |c|
    c.header        = false
    c.min_width     = 700
    c.height        = 180
    c.auto_scroll   = true
    c.rows_per_page = 50
  end

  component :animal_view do |c|
    c.header      = false
    c.min_width   = 700
    c.height      = 600
    c.auto_scroll = true
  end

  component :crop_view do |c|
    c.header        = false
    c.min_width     = 700
    c.height        = 600
    c.auto_scroll   = true
  end

  component :equipment_view do |c|
    c.header        = false
    c.min_width     = 700
    c.height        = 600
    c.auto_scroll   = true
  end

  component :customer_view do |c|
    c.header      = false
    c.min_width   = 700
    c.height      = 600
    c.auto_scroll = true
  end
end

FarmManager = MartyDemo::FarmManager
