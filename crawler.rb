require 'gmailAccessor'
require 'dbAccessor'

db = AnimeDBAccessor.new
ga = GmailAccessor.new(:unread)
ga.getAnimeList.each do |anime|
  db.regist(anime)
end

p Time.now
