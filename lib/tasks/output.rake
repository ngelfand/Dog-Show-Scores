namespace :output do
  task :dogs => :environment do
    dogs = Dog.find(:all)
    count = 0
    filecount = 0
    outfile = File.open("foo.txt", 'w')
    dogs.each do |dog|
      if count % 1000 == 0
        filename = "#{ARGV[1]}_#{filecount}.txt"
        puts filename
        outfile = File.open(filename, 'w')
        filecount += 1
      end
      
      #puts "#{dog.akc_id}; #{dog.akc_name}"
      outfile.write("#{dog.akc_id}; #{dog.akc_name}\n")
      count += 1
    end
  end

  task :recent_dogs => :environment do
    d = DateTime.civil(2011, 12, 28)
    dogs = Dog.all(:conditions => ["DATE(created_at) > DATE(?)", d])
    count = 0
    filecount = 0
    outfile = nil
    dogs.each do |dog|
      if count % 1000 == 0
        filename = "#{ARGV[1]}_#{filecount}.txt"
        puts filename
        outfile = File.open(filename, 'w')
        filecount += 1
      end
      
      #puts "#{dog.akc_id}; #{dog.akc_name}"
      outfile.write("#{dog.akc_id}; #{dog.akc_name.strip()}\n")
      count += 1
    end
  end
  
  
  task :nonfound_shows => :environment do
    showfile = File.open(ARGV[1], 'r')
    outfile = File.open(ARGV[2], 'a')
    showfile.each_line do |line|
      show_id = line
      puts show_id
      show = Show.find_by_show_id(show_id)
      if show.nil?
        puts "Not found show #{show_id}"
        outfile.write("#{show_id}")
      end
    end
  end
  
  task :judges => :environment do
    outfile = File.open(ARGV[1], 'w')
    judges = Judge.all
    judges.each do |judge|
      outfile.write("#{judge.judge_id}; #{judge.name}\n")
    end
  end
  
  task :rally_shows => :environment do
    outfile = File.open(ARGV[1], 'w')
    shows = Ralshow.all(:order => 'show_id ASC')
    shows.each do |show|
      outfile.write("#{show.show_id}\n")
    end
  end
  
  task :obed_shows => :environment do
    outfile = File.open(ARGV[1], 'w')
    shows = Show.all(:order => 'show_id ASC')
    shows.each do |show|
      outfile.write("#{show.show_id}\n")
    end
  end
end
