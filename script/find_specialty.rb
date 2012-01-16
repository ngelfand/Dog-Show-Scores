#
# Go through a list of input directories and grep for the word "specialty" in the
# html files. Add the show ID for that show to a set, and then output all the
# unique IDs. This will be used to fix the duplicate score bug that we got
# from the weird specialty result format on the AKC site.
#

require 'set'
showdirs = ARGV[0..ARGV.length]
badshows = Set.new
showdirs.each do |dir|
  files = Dir.glob("#{dir}/*.html")
  files.each do |f|
    file = File.open(f, 'r')
    file.each_line do |line|
      if (line =~ /(.*)Specialty(.*)/)
        badshows.add(dir)
        next
      end
    end
  end
end
    

output = badshows.map { |i| i.to_s }.join(" ")
command1 = "python ../scripts/parse_shows_and_results.py -o #{output}"
puts "==== First command: #{command1}"
system command1
command2 = "rake obedience:redo_scores #{output}"
puts "==== Second command: #{command2}"
system command2
puts "==== Fixed #{badshows.length} specialties"
