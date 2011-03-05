#!/usr/bin/env ruby
# An app for displaying one's resume
# @author Nat Welch - https://github.com/icco/Resume

begin
   require "rubygems"
rescue LoadError
   puts "Please install Ruby Gems to continue."
   exit
end

# Check all of the gems we need are there.
[ "sinatra", "less", "sequel" ].each {|gem|
   begin
      require gem
   rescue LoadError
      puts "The gem #{gem} is not installed.\n"
      exit
   end
}

configure do
   set :sessions, true
   DB = Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://data.db')
end

get '/' do
   filename = Dir.glob(File.join("public", "mp3s", "*.mp3")).sample
   filename = File.basename filename

   erb :index, :locals => { :filename => filename }
end

post '/' do
   e = Entry.new
   e.songname = params[:songname]
   e.mood = params[:mood]
   e.date = Time.now
   e.save

   redirect '/'
end

get '/stats' do
   entries = Entry.all
   songs = Hash.new
   entries.each {|entry|
      songs[entry.songname] = Array.new if songs[entry.songname].nil?
      songs[entry.songname].push entry.mood
   }

   erb :stats, :locals => { :entries => songs }
end

get '/style.css' do
   content_type 'text/css', :charset => 'utf-8'
   less :style
end

class Entry < Sequel::Model(:entries)
end
