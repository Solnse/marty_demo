class MartyDemo::FarmDetailView < Netzke::Base
  js_configure do |c|
    c.body_padding = 5
    c.title = "Info"
    c.update_stats = <<-JS
      function() {
        // Create and show the mask.
        this.getEl().mask();

        // Call the endpoint.
        this.serverUpdate({}, function() {
          // Hide mask. (We're in the callback function.)
          this.getEl().unmask();
          }, this);
      }
    JS
  end

  endpoint :server_update do |params, this|
    #updateBodyHtml is a JS-side method we inherit from Netzke::Basepack::Panel

    this[:update] = [body_content(farm)]
    this.set_title MartyDemo::Farm.find(manager_farm_id).name
  end

  # HTML template used to display the farm details.
  def body_content(farm)
    farm_html
  end

  def farm_html
    %Q(
        <h2>Farm: #{farm.name}</h2>
        <table>
          <tr>
            <td align='right'>Owner: </td>
            <td>#{farm.owner}</td>
          </tr>
          <tr>
            <td align='right'>County: </td>
            <td>#{farm.county}</td>
          </tr>
          <tr>
            <td align='right'>Acres: </td>
            <td>#{farm.acres}</td>
          </tr>
        </table>
      )
  end

  def manager_farm_id
    root_sess[:manager_farm_id]
  end

  private
  def farm
    @farm ||= manager_farm_id &&
      MartyDemo::Farm.find(manager_farm_id)
  end
end

FarmDetailView = MartyDemo::FarmDetailView
