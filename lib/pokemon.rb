class Pokemon
  attr_reader :id, :db
  attr_accessor :name, :type, :hp
  def initialize(id: nil,name:nil,type:nil,db: nil, hp: nil)
    @id = id
    @name = name
    @type = type
    @db = db
    @hp = hp
  end
  
  def self.save(name,type,db, hp=60)
    sql ="
      INSERT INTO pokemon (name, type, hp)
      VALUES(?, ?, ?)
    "
    db.execute(sql, name, type)
    result =db.execute("SELECT last_insert_rowid() FROM pokemon")
    Pokemon.new(id: result[0][0],name: name,type: type)
  end
  
  def self.find(id,db)
    sql = "SELECT * FROM pokemon WHERE id = ?"
    result = db.execute(sql,id)
    Pokemon.new(id: id, name: result[0][1], type: result[0][2], db: db, hp: result[0][4])
  end
  
  def alter_hp(new_hp,db)
    poke_data = Pokemon.find(self.id,self.db)
    poke_data.hp = new_hp
    poke_data.update
  end
  
  def update
    sql ="UPDATE pokemon SET name = ?, type = ?, hp = ? WHERE id = ?"
    db.execute(sql, self.name,self.type,self.hp,self.id)
  end
     
end
