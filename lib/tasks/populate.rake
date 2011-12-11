namespace :populate do
  desc 'insert scraped data into the databse'
  task :judges => :environment do
    if ARGV.length == 1
      filename == '../data/judges.txt'
    else
      filename = ARGV[1]
    end
    puts "Inserting judges from file #{filename}"
    myfile = File.open(filename, 'r')
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
    if  ARGV.length == 1
      files = ['../data/novice.txt', '../data/open.txt', '../data/utility.txt']
    else
      files = ARGV[1..ARGV.length]
    end
    
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
  
  task :shows_judges_novice => :environment do
    myfile = File.open('../data/show-judge-novice.txt')
    myfile.each_line do |line|
      data = line.split(" ")
      puts "#{data[0]} #{data[1]}"
      j = Judge.find_by_judge_id(data[0])
      s = Show.find_by_show_id(data[1])
      Obedclass.create(:judge_id => j.id, :show_id => s.id, :classname => 'novice')
    end
  end
  
  task :shows_judges_open => :environment do
    myfile = File.open('../data/show-judge-open.txt')
    myfile.each_line do |line|
      data = line.split(" ")
      puts "#{data[0]} #{data[1]}"
      j = Judge.find_by_judge_id(data[0])
      s = Show.find_by_show_id(data[1])
      Obedclass.create(:judge_id => j.id, :show_id => s.id, :classname => 'open')
    end
  end
  
  task :shows_judges_utility => :environment do
    myfile = File.open('../data/show-judge-utility.txt')
    myfile.each_line do |line|
      data = line.split(" ")
      puts "#{data[0]} #{data[1]}"
      j = Judge.find_by_judge_id(data[0])
      s = Show.find_by_show_id(data[1])
      Obedclass.create(:judge_id => j.id, :show_id => s.id, :classname => 'utility')
    end
  end
  
  
  #
  # Given a score file name, read in the scores and update the Scores table.
  # The classname parameter is stored together with the score
  #
  def process_score_file(filename, show_id, classname)
    if File.exists?(filename)
      scorefile = File.open(filename)
      place = 1
      scorefile.each_line do |line|
        data = line.split(';')
        akc_id = data[0]
        akc_name = data[1]
        breed = data[2]
        owner = data[3]
        score = data[4]
        dog = Dog.find_by_akc_id(akc_id)
        if dog.nil?
          # create a new dog entry 
          dog = Dog.create(:akc_id => akc_id, :akc_name => akc_name, 
                            :breed => breed, :owner => owner)
          # TODO: if the dog already exists, we should probably make sure
          # we have the highest title. however if we do insertions in reverse
          # date order, we may not have to because we would already have the
          # latest title first
        end
        # update the score table with the dog
        # we should probably make sure that the dog/show/class entry doesn't
        # already exist, so that we can re-run populate many times
        Obedscore.create(:show_id => show_id, :dog_id => akc_id, 
                         :classname => classname, :score => score,
                         :placement => place)
        place += 1
      end
    end
  end
  
  
  #
  # Read in the score files (typically from the dumps directory) and for each
  # file insert the data into the Scores table, and optionally into the Dogs
  # table if this is the first time the dog is encountered.
  #
  task :scores => :environment do
    # hash map of classes to abbreviations
    classnames = {'NA'=>'Novice A', 'NB'=>'Novice B', 'OA'=>'Open A', 'OB'=>'Open B',
      'UA'=>'Utility A', 'UB'=>'Utility B'}
    showdirs = ARGV[1..ARGV.length]
    showdirs.each do |dir|
      puts "Getting scores from #{dir}"
      classnames.keys.each do |classname|
        filename = "#{dir}/#{classname}.txt"
        process_score_file(filename, File.basename(dir), classnames[classname])
      end
    end
  end


end