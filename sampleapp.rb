require 'dbAccessor'

db = AnimeDBAccessor.new
db.find_all.each do |anime|
  p '=========='
  puts anime
end
