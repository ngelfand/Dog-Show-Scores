import obedience
import rally
import sys

show_type = sys.argv[1]
show_id = sys.argv[2]
dumpdir = sys.argv[3]

if show_type == '-o':
	obedience.downloadPagesForShow(show_id, dumpdir)
elif show_type == '-r':
	rally.downloadPagesForShow(show_id, dumpdir)
else:
	print "Unknown show type %s"%(show_type)