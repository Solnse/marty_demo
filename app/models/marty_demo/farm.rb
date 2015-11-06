class MartyDemo::Farm < MartyDemo::Base
  has_mcfly
  validates_presence_of :name
  mcfly_validates_uniqueness_of :name

  def self.seed
   [['Moonlight Orchards','Debussy','Marin',121],
    ['Hidden Creek Valley','Jameson','Porter',1655]
    ].each do |name, owner, county, acres|
      create(:name   => name,
             :owner  => owner,
             :county => county,
             :acres  => acres)
    end
  end
end
