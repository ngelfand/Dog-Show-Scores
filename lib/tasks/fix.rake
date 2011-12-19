namespace :fix do
  task :show_cities => :environment do
    files = ARGV[1..ARGV.length]
    
    files.each do |file|
      puts "Reading shows from files #{file}"
      myfile = File.open(file)
      myfile.each_line do |line|
        data = line.split(";")
        show_id = data[0]
        show_name = data[1].strip
        city = data[2].strip
        state = data[3].strip
        dt = data[4].strip
        puts "Show #{show_id} #{show_name} #{city} #{state} #{dt}"
        s = Show.find_by_show_id(show_id)
        s.update_attributes(:city => city)
      end
    end
  end
end