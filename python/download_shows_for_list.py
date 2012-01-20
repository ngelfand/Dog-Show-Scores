import obedience
import rally
import sys

# usage program <-o|-r> <show list> <dumpdir>
showFile = open(sys.argv[2])
dumpdir = sys.argv[3]
shows = sys.argv[1]
uniq = set()
for line in showFile:
	show_id = line.strip()
	uniq.add(show_id)
	if shows == '-o':
		obedience.downloadPagesForShow(show_id, dumpdir)
	elif shows == '-r':
		rally.downloadPagesForShow(show_id, dumpdir)
	else:
		print "Unknown show type"
		
print "Downloaded results for %d unique shows"%(len(uniq))