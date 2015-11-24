class MartyDemo::EquipmentView < Marty::McflyGridPanel
  has_marty_permissions \
  create: :any,
  read: [:any, :viewer],
  update: :any,
  delete: :any

  js_configure do |c|
    c.init_component = <<-JS
      function() {
        var me = this;

        me.callParent();

        var mev = me.getView();
        mev.getRowClass = this.getRowClass;

        mev.getSelectionModel().on('selectionchange', function(selModel) {
          var has_sel = selModel.hasSelection();
          var rec_id =
            has_sel ? mev.getSelectionModel().selected.first().getId() : null;

          for (var key in me.actions) {
            // assumes functions start with 'do'
            if (key.substring(0,2) == "do") {
              me.actions[key].setDisabled(!has_sel);
            }
          }
        });
      }
    JS

    c.get_row_class = <<-JS
      function(record, index, rowParams, ds) {
        return record.get('colorcode')+'-row';
      }
    JS
  end

  def configure(c)
    super

    c.title = "Equipment"
    c.model = MartyDemo::Equipment
    c.columns =
      [
       :name,
       :equip_type,
       :purchase_date,
       :service_date,
       :expected_replacement_date,
       :purchase_price,
       :farm__name
      ]
    c.width = 700
    c.strong_default_attrs = {farm_id: manager_farm_id}
  end

  def manager_farm_id
    root_sess[:manager_farm_id]
  end

  def get_records(params)
    data_class.where(farm_id: manager_farm_id).scoping do
      super
    end
  end

  column :name do |c|
    c.text  = 'Name'
    c.width = 100
    c.align = 'center'
  end

  column :equip_type do |c|
    c.text  = 'Type'
    c.width = 100
    c.align = 'center'
  end

  column :purchase_date do |c|
    c.text = 'Purchase Date'
    c.width = 100
  end

  column :service_date do |c|
    c.text = 'Service Date'
    c.width = 100
  end

  column :expected_replacement_date do |c|
    c.text = 'Expected Replacement Date'
    c.width = 130
  end

  column :purchase_price do |c|
    c.text = "Purchase Price"
  end

  column :farm__name do |c|
    c.text = "Farm Name"
  end
end

EquipmentView = MartyDemo::EquipmentView
