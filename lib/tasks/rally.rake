namespace :rally do
  
  #
  # Given a score file name, read in the scores and update the Scores table.
  # The classname parameter is stored together with the score
  #
  def rally_process_score_file(filename, show_id, classname, order)
    if File.exists?(filename)
      scorefile = File.open(filename)
      show = Ralshow.find_by_show_id(show_id)
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
        score = Ralscore.find_or_create_by_ralshow_id_and_dog_id_and_classname(show.id, dog.id, classname, 
                                                                    :score=>score, :placement=>place, :dog_name=>akc_name, :classorder=>order)
        place += 1
      end
    end
  end
  
  
  #
  # Process the main file from the show directory and enter the show, judge
  # and classes information into the appropriate place.
  #
  def rally_process_main_file(filename, sid)
    mainfile = File.open(filename, 'r')
    line = mainfile.gets
    data = line.split('; ')
    puts "Name=#{data[0]}, City=#{data[1]}, State=#{data[2]}, Date=#{data[3]}"
    show = Ralshow.find_or_create_by_show_id(sid, :name=>data[0], :city=>data[1],
                                            :state=>data[2], :date=>data[3])
    puts "Processing file for show #{show.name} id: #{show.id}"
    while (line = mainfile.gets)
      data = line.split('; ')
      #puts "Class=#{data[0]},Name=#{data[1]},id=#{data[2]}"
      judge = Judge.find_or_create_by_judge_id(data[2], :name=>data[1])
      ralclass = Ralclass.find_or_create_by_judge_id_and_ralshow_id_and_classname(judge.id, show.id, data[0],:dogs_in_class=>data[3])
      #puts "  Judge id: #{judge.id} Class id: #{obed.id}"
    end
  end
  
  #
  # Read in the score files (typically from the dumps directory) and for each
  # file insert the data into the Ralscores table, and optionally into the Dogs
  # table if this is the first time the dog is encountered.
  #
  task :insert_scores => :environment do
    # hash map of classes to abbreviations
    # 646532 scores should be created from data as of 12/16
    classnames = {'RNA'=>'Rally Novice A', 'RNB'=>'Rally Novice B', 'RAA'=>'Rally Advanced A', 'RAB'=>'Rally Advanced B',
      'REA'=>'Rally Excellent A', 'REB'=>'Rally Excellent B'}
    orders = {'RNA'=>1, 'RNB'=>2, 'RAA'=>3, 'RAB'=>4,'REA'=>5, 'REB'=>6}
    showdirs = ARGV[1..ARGV.length]
    showdirs.each do |dir|
      puts "Getting rally scores from #{dir}"
      classnames.keys.each do |classname|
        filename = "#{dir}/#{classname}.txt"
        rally_process_score_file(filename, File.basename(dir), classnames[classname], orders[classname])
      end
    end
  end
  
  #
  # Read in the main file from the show directory and create the necessary entires
  # in the show and judges tables.
  #
  task :insert_shows_judges => :environment do
    showdirs = ARGV[1..ARGV.length]
    showdirs.each do |dir|
      puts "Getting show info from #{dir}"
      filename = "#{dir}/main.txt"
      rally_process_main_file(filename, File.basename(dir))
    end
  end
  
  #
  # Add a classorder field to ralscores so we can sort in a reasonable way
  #
  task :add_classorder => :environment do
    puts "Novice A"
    scores = Ralscore.find_all_by_classname("Rally Novice A")
    scores.each do |score|
      Ralscore.connection.execute("UPDATE Ralscores SET classorder = 1 WHERE id = #{score.id}")
    end
    puts "Novice B"
    scores = Ralscore.find_all_by_classname("Rally Novice B")
    scores.each do |score|
      Ralscore.connection.execute("UPDATE Ralscores SET classorder = 2 WHERE id = #{score.id}")
    end
    puts "Advanced A"
    scores = Ralscore.find_all_by_classname("Rally Advanced A")
    scores.each do |score|
      Ralscore.connection.execute("UPDATE Ralscores SET classorder = 3 WHERE id = #{score.id}")
    end
    puts "Advanced B"
    scores = Ralscore.find_all_by_classname("Rally Advanced B")
    scores.each do |score|
      Ralscore.connection.execute("UPDATE Ralscores SET classorder = 4 WHERE id = #{score.id}")
    end
    puts "Excellent A"
    scores = Ralscore.find_all_by_classname("Rally Excellent A")
    scores.each do |score|
      Ralscore.connection.execute("UPDATE Ralscores SET classorder = 5 WHERE id = #{score.id}")
    end
    puts "Excellent B"
    scores = Ralscore.find_all_by_classname("Rally Excellent B")
    scores.each do |score|
      Ralscore.connection.execute("UPDATE Ralscores SET classorder = 6 WHERE id = #{score.id}")
    end
  end
end