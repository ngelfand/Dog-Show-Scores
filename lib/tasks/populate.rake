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
end