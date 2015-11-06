class MartyDemo::FarmView < Marty::McflyGridPanel
  has_marty_permissions \
  create: :any,
  read: [:any, :viewer],
  update: :any,
  delete: :any

  component :farm_view do |c|
    c.height    = 220
    c.width     = 200
    c.max_width = 200
    c.floating  = true
  end

  js_configure do |c|
    c.init_component = <<-JS
      function() {
        this.callParent();

        this.getView().getRowClass = this.getRowClass;
      }
    JS

    c.reload_animal_view = <<-JS
      function() {
        var parent = this.netzkeGetParentComponent();
        parent && parent.reloadAnimalView();
      }
    JS

    c.get_row_class = <<-JS
      function(record, index, rowParams, ds) {
        return record.get('open')+'-row';
      }
    JS
  end

  def configure(c)
    super
    c.title = "Farms"
    c.model = MartyDemo::Farm
    c.columns =
      [
       :name,
       :owner,
       :county,
       :acres
      ]
  end

  column :name do |c|
    c.text  = 'Name'
    c.width = 100
    c.align = 'center'
  end

  column :owner do |c|
    c.text = 'Owner'
    c.width = 100
  end

  column :county do |c|
    c.text = 'County'
    c.width = 100
  end

  column :acres do |c|
    c.text = 'Acreage'
    c.width = 100
  end
end

FarmView = MartyDemo::FarmView
