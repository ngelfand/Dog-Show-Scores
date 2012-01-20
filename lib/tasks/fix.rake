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

  task :dogs_in_class => :environment do
    dirs = ARGV[1..ARGV.length]
    dirs.each do |dir|
      sid = File.basename(dir)
      file = "#{dir}/main.txt"
      puts "Reading show file #{file}"
      mainfile = File.open(file)
      line = mainfile.gets
      data = line.split('; ')
      puts "Name=#{data[0]}, City=#{data[1]}, State=#{data[2]}, Date=#{data[3]}"
      show = Show.find_by_show_id(sid)
      puts "Show id: #{show.id}"
      while (line = mainfile.gets)
        data = line.split('; ')
        puts "Class=#{data[0]},Name=#{data[1]},id=#{data[2]}"
        obed = Obedclass.find_by_show_id_and_classname(show.id, data[0])
        obed.update_attributes(:dogs_in_class=>data[3])
      end
    end
  end
  
  task :dog_names => :environment do
    namefile = File.open(ARGV[1])
    namefile.each_line do |line|
      data = line.split('; ')
      akc_id = data[0]
      oldname = data[1]
      newname = data[2]
      akc_id = akc_id.strip()
      oldname = oldname.strip()
      newname = newname.strip()
      if oldname != newname
        puts "Updating #{oldname} to #{newname}"
        dog = Dog.find_by_akc_id(akc_id)
        dog.update_attributes(:akc_name => newname)
      end
    end
  end
  
  task :beginner_novice => :environment do
    obeds = Obedscore.find_all_by_classname('BeginnerNovice B')
    obeds.each do |obed|
      obed.update_attributes(:classname => 'Beginner Novice B')
    end
  end
  
  # Somehow we managed to get newlines in the dogs' names
  task :dog_name_newlines => :environment do
    dogs = Dog.find(:all)
    count = 1
    dogs.each do |d|
      if count % 10000 == 0
        puts "#{count}"
      end
      name = d.akc_name
      name = name.strip()
      str = Dog.__send__(:sanitize_sql, ["UPDATE Dogs SET akc_name=? WHERE id = #{d.id}", name])
      #puts str
      Dog.connection.execute(str)
      count += 1
    end
  end
end

