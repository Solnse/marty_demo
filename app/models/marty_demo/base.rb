class MartyDemo::Base < ActiveRecord::Base
	self.table_name_prefix = "marty_demo_"
	self.abstract_class = true
end
