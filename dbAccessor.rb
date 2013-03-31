require 'rubygems'
require 'mysql'
require 'conf' # ただの設定ファイル

class AnimeDBAccessor

  attr_accessor :client, :tb_definition
  def initialize
    @tb_definition = "CREATE TABLE `animes` (
      `id` bigint(20) NOT NULL AUTO_INCREMENT,
      `title` varchar(128) NOT NULL,
      `url` text,
      `likes` bigint(20) DEFAULT '0',
      `unlikes` bigint(20) DEFAULT '0',
      `info` binary(1) DEFAULT NULL,
      `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
      `created_at` datetime DEFAULT NULL,
      `deleted` tinyint(1) DEFAULT '0',
      PRIMARY KEY (`title`),
      UNIQUE KEY `id` (`id`)
      ) ENGINE=InnoDB DEFAULT CHARSET=utf8"
    #@client = Mysql.connect(DB_HOST, DB_USER, DB_PASS, DB_NAME)
    @client = Mysql.connect('localhost', DB_USER, DB_PASS, DB_NAME)
  end

  def init_table
    drop_st   = 'DROP TABLE IF EXISTS animes'
    @client.query(drop_st)
    @client.query(@tb_definition)
  end

  def regist(anime=nil)
    unless anime.nil?
      insert_st = "INSERT IGNORE INTO animes (title, url, created_at) VALUE ('" + anime['title'] + "', '" + anime['url'] + "', NOW())"
      @client.query(insert_st)
    end
  end

  # pagingとかサポートしたい
  def find(options=nil)
    select_st = "SELECT * FROM animes"
    @client.query(select_st).each do |row|
      p row
    end
  end

  def find_all
    select_st = "SELECT * FROM animes ORDER BY unlikes, likes"
    return @client.query(select_st)
  end
end

# test
=begin
model = AnimeDBAccessor.new
res = model.find_all
res.each do |anime|
  p anime
end
=end
