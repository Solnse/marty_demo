class Orion::Base < ActiveRecord::Base
	self.table_name_prefix = "orion_"
	self.abstract_class = true
end
