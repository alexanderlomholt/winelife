task :correct_temp => :environment do

  total = Wine.where.not(serving_temperature: nil).count
  count = 0
  Wine.where.not(serving_temperature: nil).each do |wine|
    # if wine.serving_temperature[0] == " "
      wine.serving_temperature = wine.serving_temperature.gsub(/\A\p{Space}*/, '')
      p wine.serving_temperature
      wine.save!
    # end
    count += 1
    puts "-----------#{count}/#{total}----------"
  end

end
