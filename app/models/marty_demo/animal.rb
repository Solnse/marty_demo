class MartyDemo::Animal < MartyDemo::Base
  has_mcfly
  validates_presence_of :tag, :name
  mcfly_validates_uniqueness_of :tag
  mcfly_belongs_to :farm, :class_name => MartyDemo::Farm
end
