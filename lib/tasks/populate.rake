namespace :populate do
  desc 'insert scraped data into the databse'
  task :judges => :environment do
    if ARGV.length == 1
      filename == 'data/judges.txt'
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
      files = ['data/novice.txt', 'data/open.txt', 'data/utility.txt']
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
    myfile = File.open('data/show-judge-novice.txt')
    myfile.each_line do |line|
      data = line.split(" ")
      puts "#{data[0]} #{data[1]}"
      j = Judge.find_by_judge_id(data[0])
      s = Show.find_by_show_id(data[1])
      Obedclass.create(:judge_id => j.id, :show_id => s.id, :classname => 'novice')
    end
  end
  
  task :shows_judges_open => :environment do
    myfile = File.open('data/show-judge-open.txt')
    myfile.each_line do |line|
      data = line.split(" ")
      puts "#{data[0]} #{data[1]}"
      j = Judge.find_by_judge_id(data[0])
      s = Show.find_by_show_id(data[1])
      Obedclass.create(:judge_id => j.id, :show_id => s.id, :classname => 'open')
    end
  end
  
  task :shows_judges_utility => :environment do
    myfile = File.open('data/show-judge-utility.txt')
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
    created = 0
    updated = 0
    if File.exists?(filename)
      scorefile = File.open(filename)
      show = Show.find_by_show_id(show_id)
      place = 1
      scorefile.each_line do |line|
        data = line.split(';')
        akc_id = data[0]
        akc_name = data[1]
        breed = data[2]
        owner = data[3]
        score = data[4]
        dog = Dog.find_or_create_by_akc_id(akc_id, :akc_name => akc_name, 
                          :breed => breed, :owner => owner)
        # update the score table with the dog
        # show and dog ids have to be the ids (primary keys) in the respective
        # tables, because otherwise rails doesn't correctly pick up the
        # many-many relationship
        # and how's this for an awesomely long function name?
        obscore = Obedscore.find_by_show_id_and_dog_id_and_classname(show.id, dog.id, classname)
        if obscore.nil?
          Obedscore.create(:show_id => show.id, :dog_id => dog.id, :classname => classname,
                            :score => score, :placement => place,
                            :dog_name => akc_name)
          created += 1
        else
          # update the non-key fields
          obscore.update_attributes(:score=>score, :placement=>place, :dog_name=>akc_name)
          updated += 1
        end
                          
        place += 1
      end
      puts "#{filename } Created #{created} scores. Updated #{updated} scores."
    end
  end
  
  
  #
  # Process the main file from the show directory and enter the show, judge
  # and classes information into the appropriate place.
  #
  def process_main_file(filename, sid)
    mainfile = File.open(filename, 'r')
    line = mainfile.gets
    data = line.split('; ')
    #puts "Name=#{data[0]}, City=#{data[1]}, State=#{data[2]}, Date=#{data[3]}"
    show = Show.find_or_create_by_show_id(sid, :name=>data[0], :city=>data[1],
                                          :state=>data[2], :date=>data[3])
    puts "Show id: #{show.id}"
    while (line = mainfile.gets)
      data = line.split('; ')
      #puts "Class=#{data[0]},Name=#{data[1]},id=#{data[2]}"
      judge = Judge.find_or_create_by_judge_id(data[2], :name=>data[1])
      obed = Obedclass.find_or_create_by_judge_id_and_show_id_and_classname(judge.id, show.id, data[0])
      puts "  Judge id: #{judge.id} Class id: #{obed.id}"
    end
  end
  
  #
  # Read in the score files (typically from the dumps directory) and for each
  # file insert the data into the Scores table, and optionally into the Dogs
  # table if this is the first time the dog is encountered.
  #
  task :scores => :environment do
    # hash map of classes to abbreviations
    # 646532 scores should be created from data as of 12/16
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
  
  #
  # Read in the main file from the show directory and create the necessary entires
  # in the show and judges tables.
  #
  task :shows_judges => :environment do
    showdirs = ARGV[1..ARGV.length]
    showdirs.each do |dir|
      puts "Getting show info from #{dir}"
      filename = "#{dir}/main.txt"
      process_main_file(filename, File.basename(dir))
    end
  end
end
