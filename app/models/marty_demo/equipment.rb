class MartyDemo::Equipment < MartyDemo::Base
  has_mcfly
  validates_presence_of :name
  mcfly_validates_uniqueness_of :name
  mcfly_belongs_to :farm, :class_name => MartyDemo::Farm
end
