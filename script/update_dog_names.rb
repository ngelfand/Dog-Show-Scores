#
# Get a list of dog names, run a script to download the new names from AKC and then update
# the names in the database
#

outdir = 'tmp'
command1 = "rake output:dogs #{outdir}/dogs"
puts "===Executing #{command1}"
#system command1

name_files = Dir.glob("#{outdir}/dogs*")
new_files = []
threads = []
name_files.each do |file|
  threads << Thread.new {
    new_name = "#{outdir}/new_#{File.basename(file)}"
    new_files.push(new_name)
    command2 = "python python/download_dog_names.py #{file} #{new_name}"
    puts "===Executing #{command2}"
    system command2
  }
end

threads.each { |aThread|  aThread.join }

new_files.each do |file|
  command3 = "rake fix:dog_names #{file} >> name_changes.txt"
  puts "===Executing #{command3}"
  system command3
end