



class Song

   attr_accessor :name, :album
   attr_reader :id
   
     def initialize(id=nil, name, album)
       @id = id
       @name = name
       @album = album
     end
   
     def self.create_table
       sql =  <<-SQL
         CREATE TABLE IF NOT EXISTS songs (
           id INTEGER PRIMARY KEY,
           name TEXT,
           album TEXT
           )
           SQL
       DB[:conn].execute(sql)
     end
   
     # making sure save method cannot create duplicates by comparing id to nil
     # if the id of instance trying to save is not nil then self.update
     # otherwise INSERT INTO songs and assign id 
     def save
      if self.id
         self.update
      else
         sql = <<-SQL
            INSERT INTO songs (name, album)
            VALUES (?, ?)
         SQL
   
         DB[:conn].execute(sql, self.name, self.album)
         @id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]
         end
     end
   
     def self.create(name:, album:)
       song = Song.new(name, album)
       song.save
       song
     end
   
     def self.find_by_name(name)
       sql = "SELECT * FROM songs WHERE name = ?"
       result = DB[:conn].execute(sql, name)[0]
       Song.new(result[0], result[1], result[2])
     end
   end


#### sql UPDATE statment ####
# '''sql
# UPDATE songs
# SET album = "The Black Album"
# WHERE name = "99 Problems";
# '''

#### using SQLite3-Ruby gem magic ####

# using bound parameters to pass argument through execute method

# sql = "UPDATE songs SET album = ? WHERE name = ?"
#
# DB[:conn].execute)sql, ninety_nine_problems.album, ninety_nine_problems.name)




# should identify correct record to update based on the
# unique ID that both the song Ruby object and
# the songs table row share:
def update
   sql = "UPDATE songs SET name = ?, album = ? WHERE id = ?"
   DB[:conn].execute(sql, self.name, self.album, self.id)
end