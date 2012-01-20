import obedience
import sys

#
# Diff two files and write all shows that are in file 2 and not in file 1 into a file.

currentfile = open(sys.argv[1], 'r')
newfile = open(sys.argv[2], 'r')
outfile = open(sys.argv[3], 'w')

currentshows = {}
for line in currentfile:
	data = line.strip()
	currentshows[data] = data
	
print "Read %d current shows"%(len(currentshows))

newshows = []
for line in newfile:
	data = line.strip()
	newshows.append(data)
	
print "Read %d new shows"%(len(newshows))

# diff
for show in newshows:
	if not currentshows.has_key(show):
		outfile.write("%s\n"%(show))


