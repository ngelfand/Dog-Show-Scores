import obedience
import rally
import sys

# usage: command -o|-r <calendar.html> <dumpdir>
if sys.argv[1] == '-o':
	obedience.downloadPagesForCalendar(sys.argv[2], sys.argv[3])
elif sys.argv[1] == '-r':
	rally.downloadPagesForCalendar(sys.argv[2], sys.argv[3])
else:
	print 'Unknown show type'