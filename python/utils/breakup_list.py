import sys

# usage program number show list output_prefix
# read in a show file, sort shows by date, and write then out
# in chunks

chunkSize = int(sys.argv[1])
showFile = open(sys.argv[2])
prefix = sys.argv[3]

shows = []
for line in showFile:
	show_id = int(line.strip())
	shows.append(show_id)
	
shows.sort()

# now chunk them up
count = 0
fileCount = 1
outFile = open('%s_%s.txt'%(prefix, fileCount), 'w')
for sid in shows:
	outFile.write('%d\n'%(sid))
	count += 1
	if count % chunkSize == 0:
		outFile.close()
		fileCount += 1
		outFile = open('%s_%s.txt'%(prefix, fileCount), 'w')
	
        
