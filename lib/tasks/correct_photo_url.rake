task :correct_photo_url => :environment do

  total = Wine.count
  count = 0
  Wine.all.each do |wine|
    code = wine.saq_code.to_s
    if code.length == 7
      code = "0" + code
      p wine.photo_url = "http://s7d9.scene7.com/is/image/SAQ/" + code + "-1"
      wine.save!
    elsif code.length == 6
      code = "00" + code
      p wine.photo_url = "http://s7d9.scene7.com/is/image/SAQ/" + code + "-1"
      wine.save!
    else
      puts "Wine not changed"
    end
    count += 1
    puts "-----------#{count}/#{total}----------"
  end

end
