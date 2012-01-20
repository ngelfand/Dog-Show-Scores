# Take a list of files with show information and create one large master
# list by removing duplicates. Then, break up the list into lists of certain
# size for later processing in batches. 
# usage: merge-shows [chunk size] [output prefix] [file list]

import sys
import os

if len(sys.argv) < 3:
	print 'usage: merge-shows [chunk size] [output prefix] [file list]'
	sys.exit(-1)
	
	
chunkSize = int(sys.argv[1])
prefix = sys.argv[2]
shows = {} # keys are show ids

for i in range(3, len(sys.argv)):
	print 'Pricessing file', sys.argv[i]
	infile = open(sys.argv[i], 'r')
	for line in infile:
		sid, name, city, state, date = line.split(';')
		sid = int(sid.strip())
		name = name.strip()
		city = city.strip()
		state = state.strip()
		date = date.strip()
		showInfo = (name, city, state, date)
		if (shows.has_key(sid) and showInfo != shows[sid]):
			# the shows from before 2000 seems to have the same id for
			# two-day shows. However, we cannot get good results from
			# them anyway, so ignore those collisions
			if (sid > 2000000000):
				print 'Collision, same id, but different data!'
				print  '    ', sid, showInfo, shows[sid]
		shows[sid] = (name, city, state, date)
		
print 'Unique shows:', len(shows)

# now sort the keys, and dump out the sorted key, value pairs
sortedSids = shows.keys()
sortedSids.sort()

# first, dump all shows into a file
outFile  = open('%s.txt'%(prefix), 'w')
for sid in sortedSids:
	showInfo = shows[sid]
	outFile.write('%d; %s; %s; %s; %s\n'%(sid, showInfo[0], showInfo[1], showInfo[2], showInfo[3]))
outFile.close()

# now chunk them up
count = 1
fileCount = 1
outFile = open('%s_%s.txt'%(prefix, fileCount), 'w')
for sid in sortedSids:
	showInfo = shows[sid]
	if count % chunkSize == 0:
		outFile.close()
		fileCount += 1
		outFile = open('%s_%s.txt'%(prefix, fileCount), 'w')
	outFile.write('%d; %s; %s; %s; %s\n'%(sid, showInfo[0], showInfo[1], showInfo[2], showInfo[3]))
	count += 1
	
	
	

