import os
import sys
from BeautifulSoup import BeautifulSoup
import re
import obedience

##########################################################
def usage():
	print 'usage: parse_results.py infile.html outfile.txt'
	print '   or: parse_results.py dirname'


##########################################################
# GO!
if len(sys.argv) == 3:
	obedience.parseResults(sys.argv[1], sys.argv[2])
elif len(sys.argv) == 2:
	obedience.parseResultsDir(sys.argv[1])
else:
	usage()
	sys.exit(0)
	
