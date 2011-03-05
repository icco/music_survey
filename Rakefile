desc "Create local db."
task :db do
   require "sequel"

   DB = Sequel.connect(ENV['DATABASE_URL'] || "sqlite://data.db")
   DB.create_table! :entries do
      primary_key :entryid
      String   :songname,  :default => ""
      String   :mood,  :default => ""
      DateTime :date
   end 

   puts "Database built."
end

