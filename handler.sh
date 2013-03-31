
while true
  do
    ruby ./crawler.rb
    date
    sleep `expr 60 \* 60 \* 24`
  done
