class MartyDemo::Farm < MartyDemo::Base
  has_mcfly
  validates_presence_of :name
  mcfly_validates_uniqueness_of :name
end
