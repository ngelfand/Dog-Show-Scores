from obedience import *
import os
import sys
from BeautifulSoup import BeautifulSoup
import re
import urllib2
import time
import datetime
import socket
socket.setdefaulttimeout(300)

def downloadNonRegularClassPagesForShow(showFile, showDir, sid):
	showBNAFile = '%s/BNA.html'%(showDir)
	showBNBFile = '%s/BNB.html'%(showDir)
	showGNFile = '%s/GN.html'%(showDir)
	showGOFile = '%s/GO.html'%(showDir)
	showVFile = '%s/V.html'%(showDir)


	soup = BeautifulSoup(open(showFile, 'r'))
	#for s in soup.findAll(text=re.compile('^Beginner Novice|^Obedience Beginner Novice|^Obedience Graduate Novice|^Graduate Novice|^Obedience Graduate Open|^Graduate Open|^Versatility|^Obedience Versatility|^Reg, Versatility')):
	for s in soup.findAll(text=re.compile('^Versatility|^Obedience Versatility|^Reg, Versatility')):

		try:
			classRef = s.parent.previousSibling.contents[1]['name']
			print s, classRef
			# show sub-results look like this, classRef is the internal reference to a sub-result
			# /events/search/index_results.cfm?action=event_info&comp_type=O&status=RSLT&int_ref=5&event_number=2005035302&cde_comp_group=CONF&cde_comp_type=O&NEW_END_DATE1=&key_stkhldr_event=&mixed_breed=N
			classUrl = 'http://www.akc.org/events/search/index_results.cfm?action=event_info&comp_type=O&status=RSLT&int_ref=%s&event_number=%s&cde_comp_group=CONF&cde_comp_type=O&NEW_END_DATE1=&key_stkhldr_event=&mixed_breed=N'%(classRef, sid)
			# these are not necessarily in order, so we need to see what name of the class wass
			if s == 'Obedience Beginner Novice A' or s == 'Beginner Novice A':
				localFile = open(showBNAFile, 'w')
			elif s == 'Obedience Beginner Novice B' or s == 'Beginner Novice B':
				localFile = open(showBNBFile, 'w')	
			elif s == 'Obedience Graduate Novice' or s == 'Graduate Novice':
				localFile = open(showGNFile, 'w')
			elif s == 'Obedience Graduate Open' or s == 'Graduate Open':
				localFile = open(showGOFile, 'w')
			elif s == 'Obedience Versatility' or s == 'Versatility' or s == 'Reg, Versatility':
				localFile = open(showVFile, 'w')
			classFile = urllib2.urlopen(classUrl, timeout = 30)
			print classUrl
			localFile.write(classFile.read())
		except AttributeError:
			# something went wrong with parsing, log it and move on
			errorLog('Something wrong with parsing file %s\n'%(showFile))
			
			
def parseNonRegularClasses(dumpdir):
	#classes = ['BNA', 'BNB', 'GN', 'GO', 'V']
	classes = ['V']
	for c in classes:
		infile = "%s/%s.html"%(dumpdir, c)
		outfile = "%s/%s.txt"%(dumpdir, c)
		# check if the file exists
		if os.path.exists(infile):
			parseResults(infile, outfile)
			
			
#
# Download into a set of already existing directories, the non-regular classes.
#

for dirname in sys.argv[1:]:
	print dirname
	mainhtml = "%s/main.html"%(dirname)
	maintxt = "%s/main.txt"%(dirname)
	# download the pages
	downloadNonRegularClassPagesForShow(mainhtml, dirname, os.path.basename(dirname))
	# we need to re-parse the main file to get the correct class numbers
	parseShowMainFile(mainhtml, maintxt)
	# parse the pages
	parseNonRegularClasses(dirname)
	