require 'rubygems'
require 'gmail' # sudo gem install ruby-gmail
require 'conf' # ただの設定ファイル
require 'kconv'

MAIL_DELIMITER = "------------------------------------------------\r\n"

class GmailAccessor 
  attr_accessor :gmail, :opt
  def initialize(opt=:read)
    @gmail = Gmail.new(USERNAME,PASSWORD)
    @opt = opt
  end

  def getAnimeList
    list = []
    mails = @gmail.inbox.emails(@opt).map do |mail|
      #本文処理
      if !mail.text_part && !mail.html_part
        entirebody = Kconv.toutf8(mail.body.decoded)
        #entirebody = mail.body.decoded
        splited = entirebody.split(MAIL_DELIMITER)
        splited.each_with_index do |elm, i|
          if /[0-9]+:[0-9]+/ =~ elm
            val = splited[i + 1].split("\n")
            info = {
              "channel" => val[0],
              "title"   => val[1],
              "sprint"  => val[2],
              "url"     => val[3]
            }
            list.push(info);
          end
          #puts elm
        end
      elsif mail.text_part
        #puts "text: " + Kconv.toutf8(mail.text_part.decoded)
      elsif mail.html_part
        #puts "html: " + Kconv.toutf8(mail.html_part.decoded)
      end
    end
    return list
  end
end 

# test
=begin
ga = GmailAccessor.new()
ga.getAnimeList.each do |anime|
  puts 'CHANNEL :' + anime['channel']
  puts 'TITLE   :' + anime['title']
  puts 'SPRINT  :' + anime['sprint']
  puts 'URL     :' + anime['url']
end
=end
