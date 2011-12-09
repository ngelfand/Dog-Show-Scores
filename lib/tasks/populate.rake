namespace :populate do
  desc 'insert scraped data into the databse'
  task :judges => :environment do
    puts "Inserting judges from file #{ARGV[1]}"
    myfile = File.open(ARGV[1], 'r')
    myfile.each_line do |line|
      data = line.split(";")
      judge_id = data[0]
      judge_name = data[1]
      judge_name = judge_name.strip
      puts "Judge id [#{judge_id}] name [#{judge_name}]"
      Judge.create(:judge_id=>judge_id, :name=>judge_name)
    end
  end
  
  task :shows => :environment do
    files = ARGV[1..ARGV.length]
    files.each do |file|
      puts "Inserting shows from files #{file}"
      myfile = File.open(file)
      myfile.each_line do |line|
        data = line.split(";")
        show_id = data[0]
        show_name = data[1].strip
        city = data[2].strip
        state = data[3].strip
        dt = data[4].strip
        puts "Show #{show_id} #{show_name} #{city} #{state} #{dt}"
        Show.create(:show_id=>show_id, :name=>show_name, 
                    :city=>city, :state=>state, :date=>dt)
      end
    end
  end
end