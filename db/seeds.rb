login     = 'cedie' # your windows login name
firstname = 'Chad'
lastname  = 'Edie'
if !Marty::User.find_by_login(login)
  user           = Marty::User.new
  user.login     = login
  user.firstname = firstname
  user.lastname  = lastname
  user.active    = true
  user.save!

  Marty::Role.all.map do |role|
    ur = Marty::UserRole.new
    ur.user = user
    ur.role = role
    ur.save!
  end
end


unless Rails.env.production?
  Mcfly.whodunnit = Marty::User.find_by_login('cedie')

  [['Moonlight Orchards','Debussy','Marin',121],
   ['Hidden Creek Valley','Jameson','Porter',1655]
  ].each do |name, owner, county, acres|
    MartyDemo::Farm.create(:name   => name,
                           :owner  => owner,
                           :county => county,
                           :acres  => acres)
  end

  [[100,'Piggy Sue','pig','female','dirty'],
   [200,'Hamlet','pig','male','the king!']
  ].each do |tag, name, family, gender, desc|
    MartyDemo::Animal.create(:tag         => tag,
                             :name        => name,
                             :family      => family,
                             :gender      => gender,
                             :description => desc,
                             :farm_id     => MartyDemo::Farm.first.id)
  end

  [['Asparagus','Spring','3.00','Fresh from the field'],
   ['Pumpkin','Fall','1.00','Halloween is here!']
  ].each do |name, season, price, desc|
    MartyDemo::Crop.create(:farm_id => MartyDemo::Farm.second.id,
                           :name        => name,
                           :season      => season,
                           :price       => price,
                           :description => desc)
  end

  [['Bill Smith','ACME','805-555-1212','2015-12-01','company buyer'],
   ['Janice Reece','Bixby Growers','805-888-1212','2015-12-02','fertilizer']
  ].each do |name, company, phone, join_date, desc|
    MartyDemo::Customer.create(:farm_id => MartyDemo::Farm.all.shuffle.first.id,
                               :name        => name,
                               :company     => company,
                               :phone       => phone,
                               :join_date   => join_date,
                               :description => desc)
  end

  [['Bessie','Tractor','2015-12-01','2016-06-01','2035-12-01',35000],
   ['Widow Maker','grape masher','2015-12-01','2016-06-01','2021-01-01',12000]
  ].each do |name, equip_type, purchase_date, serv_date, repl_date, price|
    MartyDemo::Equipment.create(:farm_id => MartyDemo::Farm.all.shuffle.
                                              first.id,
                                :name                      => name,
                                :equip_type                => equip_type,
                                :purchase_date             => purchase_date,
                                :service_date              => serv_date,
                                :expected_replacement_date => repl_date,
                                :purchase_price            => price)
  end
end
