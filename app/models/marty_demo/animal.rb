class MartyDemo::Animal < MartyDemo::Base
  has_mcfly
  validates_presence_of :tag, :name
  mcfly_validates_uniqueness_of :tag
  mcfly_belongs_to :farm, :class_name => MartyDemo::Farm

  def self.seed
   [[100,'Piggy Sue','pig','female','dirty'],
    [200,'Hamlet','pig','male','the king!']
    ].each do |tag, name, family, gender, desc|
      create(:tag         => tag,
             :name        => name,
             :family      => family,
             :gender      => gender,
             :description => desc,
             :farm_id     => MartyDemo::Farm.first.id)
    end
  end
end
