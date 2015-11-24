class MartyDemo::CropView < Marty::McflyGridPanel
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

    c.title = "Crops"
    c.model = MartyDemo::Crop
    c.columns =
      [
       :name,
       :price,
       :season,
       :description,
       :farm__name
      ]
    c.width = 700
    c.strong_default_attrs = { farm_id: manager_farm_id }
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

  column :price do |c|
    c.text  = 'Price'
    c.width = 100
    c.align = 'center'
  end

  column :season do |c|
    c.text = 'Season'
    c.width = 100
  end

  column :description do |c|
    c.text = 'Notes'
    c.width = 100
  end

  column :farm__name do |c|
    c.text = "Farm Name"
  end
end

CropView = MartyDemo::CropView
