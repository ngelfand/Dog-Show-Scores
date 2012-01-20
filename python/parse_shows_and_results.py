import obedience
import rally
import sys

# parse a list of directories and strip out the information from main.html and {class}.html
# pages and put them in text files

if len(sys.argv) < 1:
	print 'usage: command  -o|-r [dirs]'
	sys.exit(-1)
	
shows = sys.argv[1]
for dirname in sys.argv[2:]:
	print dirname
	mainhtml = "%s/main.html"%(dirname)
	maintxt = "%s/main.txt"%(dirname)
	obedience.parseShowMainFile(mainhtml, maintxt)
	if shows == '-o':
		obedience.parseResultsDir(dirname)
	elif shows == '-r':
		rally.parseResultsDir(dirname)
	else:
		print "Unknown show type"