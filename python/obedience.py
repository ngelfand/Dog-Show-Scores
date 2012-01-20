#
# Module with functions for parsing AKC obedience show results.
#

import os
import sys
from BeautifulSoup import BeautifulSoup
import re
import urllib2
import time
import datetime

from common_utils import *


##################################################################
##################################################################
# FUNCTIONS FOR DOWNLOADING SHOW RESULTS
##################################################################
##################################################################


	
##################################################################
# Parse out the results of the show from a (local) show page
# Download the show files into the appropriately named files
# in dumpdir.
##################################################################
def downloadClassPagesForShow(showFile, sid, dumpdir):
	showNovAFile = '%s/%s/NA.html'%(dumpdir, sid)
	showNovBFile = '%s/%s/NB.html'%(dumpdir, sid)
	showOpenAFile = '%s/%s/OA.html'%(dumpdir, sid)
	showOpenBFile = '%s/%s/OB.html'%(dumpdir, sid)
	showUtAFile = '%s/%s/UA.html'%(dumpdir, sid)
	showUtBFile = '%s/%s/UB.html'%(dumpdir, sid)
	showBNAFile = '%s/%s/BNA.html'%(dumpdir, sid)
	showBNBFile = '%s/%s/BNB.html'%(dumpdir, sid)
	showGNFile = '%s/%s/GN.html'%(dumpdir, sid)
	showGOFile = '%s/%s/GO.html'%(dumpdir, sid)
	showVFile = '%s/%s/V.html'%(dumpdir, sid)
	
	
	soup = BeautifulSoup(open(showFile, 'r'))
	for s in soup.findAll(text=re.compile('^Novice|^Open|^Utility|^Obedience Novice|^Obedience Open|^Obedience Utility|^Beginner Novice|^Obedience Beginner Novice|^Obedience Graduate Novice|^Graduate Novice|^Obedience Graduate Open|^Graduate Open|^Versatility|^Obedience Versatility|^Reg, Versatility')):
		try:
			classRef = s.parent.previousSibling.contents[1]['name']
			print s, classRef
			# show sub-results look like this, classRef is the internal reference to a sub-result
			# /events/search/index_results.cfm?action=event_info&comp_type=O&status=RSLT&int_ref=5&event_number=2005035302&cde_comp_group=CONF&cde_comp_type=O&NEW_END_DATE1=&key_stkhldr_event=&mixed_breed=N
			classUrl = 'http://www.akc.org/events/search/index_results.cfm?action=event_info&comp_type=O&status=RSLT&int_ref=%s&event_number=%s&cde_comp_group=CONF&cde_comp_type=O&NEW_END_DATE1=&key_stkhldr_event=&mixed_breed=N'%(classRef, sid)
			# these are not necessarily in order, so we need to see what name of the class wass
			if s == 'Obedience Novice A' or s == 'Novice A':
				localFile = open(showNovAFile, 'w')
			elif s == 'Obedience Novice B' or s == 'Novice B':
				localFile = open(showNovBFile, 'w')
			elif s == 'Obedience Open A' or s == 'Open A':
				localFile = open(showOpenAFile, 'w')
			elif s == 'Obedience Open B' or s == 'Open B':
				localFile = open(showOpenBFile, 'w')
			elif s == 'Obedience Utility A' or s == 'Utility A':
				localFile = open(showUtAFile, 'w')
			elif s == 'Obedience Utility B' or s == 'Utility B':
				localFile = open(showUtBFile, 'w')
			elif s == 'Obedience Beginner Novice A' or s == 'Beginner Novice A':
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
			
			
##################################################################
# Download the main and results for show with a given id and put them 
# the appropriately named file in dumpdir.
##################################################################					
def downloadPagesForShow(sid, dumpdir):
	# if we can't make the output directory, we should quit, so don't catch the exception
	dirname = '%s/%s'%(dumpdir, sid)
	if (not os.path.exists(dirname)):
		os.makedirs(dirname)
		
	showUrl = 'http://www.akc.org/events/search/index_results.cfm?action=event_info&comp_type=O&status=RSLT&event_number=%s&cde_comp_group=CONF&cde_comp_type=O&NEW_END_DATE1=&key_stkhldr_event=&mixed_breed=N'%(sid)
	showFile = '%s/%s/main.html'%(dumpdir, sid)


	print 'Getting results for %s. Dumping pages to %s'%(showUrl, dirname)
	try:
		show = urllib2.urlopen(showUrl, timeout=30)
		localFile = open(showFile, 'w')
		localFile.write(show.read())
		localFile.close()
		downloadClassPagesForShow(showFile, sid, dumpdir)
	except urllib2.URLError:
		errorLog('Could not open show file for %s\n'%(sid))
		
		
##################################################################
# Parse an AKC monthly results calendar and extract a list of
# shows out of it. Download the main page of each of the shows
# into a given directory.
##################################################################
def downloadPagesForCalendar(inname, dumpdir):
	infile = open(inname, 'r')
	soup = BeautifulSoup(infile)
	# all we care about are the even id's
	# we want the lines that look like this: 
	# <div align="center"><strong>Event Number: </strong> 2011025109</div>
	for s in soup.findAll(text=re.compile('Event Number: ')):
		try:
			show_id =  s.parent.nextSibling.strip()
			downloadPagesForShow(show_id, dumpdir)
		except AttributeError:
			continue
					
	
					
##################################################################
##################################################################
# FUNCTIONS FOR PARSING AKC FILES AND SHOW RESULTS
##################################################################
##################################################################

##########################################################
# Parse a show main file (mail.html in the show directory)
# and create a main.txt file with the show id, name, city, state, date
# Also parse out the classes, number of dogs in each class
# and the judge for each class
##########################################################
def parseShowMainFile(inName, outName):
	print 'Parsing', inName
	infile = open(inName, 'r')
	outfile = open(outName, 'w')
	soup = BeautifulSoup(infile)
	
	# parse out the show information
	showpar = soup.findAll(colspan=8)[1]
	name = showpar.contents[0].contents[1].contents[0].contents[0].string.strip()
	dates = showpar.contents[2].contents[1].string.strip().split(' -')
	date = dates[0]
	citystate = showpar.contents[2].contents[3].contents[3].contents[1].string.strip()
	# clean up the strings
	(city, state) = citystate.split(', ')
	# parse date like this Sunday, November 13, 2011 into an actual date
	date = time.strftime("%m/%d/%y", time.strptime(date, "%A, %B %d, %Y"))
	print("%s; %s; %s; %s"%(name, city, state, date))
	outfile.write("%s; %s; %s; %s\n"%(name, city, state, date))
	
	# and now for some extra fun, parse the class names, judge names, and total dogs
	# in each class
	prog_jid = re.compile("([0-9]+)$")
	for s in soup.findAll(text=re.compile('^Novice|^Open|^Utility|^Obedience Novice|^Obedience Open|^Obedience Utility|^Beginner Novice|^Obedience Beginner Novice|^Obedience Graduate Novice|^Graduate Novice|^Obedience Graduate Open|^Graduate Open|^Versatility|^Obedience Versatility|^Reg, Versatility|^Rally Novice|^Rally Advanced|^Rally Excellent')):
		#print '[',s.parent.parent.parent.parent.parent.contents[0],']'
		#print '[',s.parent.parent.parent.parent.parent.contents[1],']'
		#print '[',s.parent.parent.parent.parent.parent.contents[2],']'
		#print '[',s.parent.parent.parent.parent.parent.contents[3],']'
		#print '[',s.parent.parent.parent.parent.parent.contents[4],']'
		#print '[',s.parent.parent.parent.parent.parent.contents[5],']'
		#print '[',s.parent.parent.parent.parent.parent.contents[6],']'
		#print '=========='
		# remove the obedience part from the class name because it's annoying
		classname = s.replace('Obedience', '')
		classname = classname.replace('Reg, ', '')
		classname = classname.strip()
		judge_id = s.parent.parent.parent.parent.parent.contents[3].contents[1].contents[1]['href']
		#print judge_id
		m = prog_jid.search(judge_id)
		judge_id = m.group(1)
		judge_name = s.parent.parent.parent.parent.parent.contents[3].contents[1].contents[1].string.strip()
		total = s.parent.parent.parent.parent.parent.contents[5].contents[1].contents[0].strip('(ent)')
		print classname, judge_name, judge_id, total
		outfile.write("%s; %s; %s; %s\n"%(classname,judge_name,judge_id,total))
	outfile.close()
	
	
##########################################################
# Go through a directory and parse all the results files found in it
##########################################################			
def parseResultsDir(dumpdir):
	classes = ['NA', 'NB', 'OA', 'OB', 'UA', 'UB', 'BNA', 'BNB', 'GN', 'GO', 'V']
	for c in classes:
		infile = "%s/%s.html"%(dumpdir, c)
		outfile = "%s/%s.txt"%(dumpdir, c)
		# check if the file exists
		if os.path.exists(infile):
			parseResults(infile, outfile)
			
				
if __name__ == '__main__':
	parseShowMainFile(sys.argv[1], sys.argv[2])