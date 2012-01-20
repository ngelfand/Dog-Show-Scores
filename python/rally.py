#
# Module with functions for parsing AKC rally show results.
#

import os
import sys
from BeautifulSoup import BeautifulSoup
import re
import urllib2
import time
import datetime
from common_utils import *

#################################################################
# Parse out the results of the show from a (local) show page
# Download the show files into the appropriately named files
# in dumpdir.
##################################################################
def downloadClassPagesForShow(showFile, sid, dumpdir):
	showRallyNovAFile = '%s/%s/RNA.html'%(dumpdir, sid)
	showRallyNovBFile = '%s/%s/RNB.html'%(dumpdir, sid)
	showRallyAdvAFile = '%s/%s/RAA.html'%(dumpdir, sid)
	showRallyAdvBFile = '%s/%s/RAB.html'%(dumpdir, sid)
	showRallyExAFile = '%s/%s/REA.html'%(dumpdir, sid)
	showRallyExBFile = '%s/%s/REB.html'%(dumpdir, sid)	
	doneFile = '%s/%s/.done'%(dumpdir, sid)
		
	soup = BeautifulSoup(open(showFile, 'r'))
	for s in soup.findAll(text=re.compile('^Rally Novice|^Rally Excellent|^Rally Advanced')):
		try:
			classRef = s.parent.previousSibling.contents[1]['name']
			print s, classRef
			# show sub-results look like this, classRef is the internal reference to a sub-result
			classUrl = 'http://www.akc.org/events/search/index_results.cfm?action=event_info&comp_type=RLY&status=RSLT&int_ref=%s&event_number=%s&cde_comp_group=CONF&cde_comp_type=O&NEW_END_DATE1=&key_stkhldr_event=&mixed_breed=N'%(classRef, sid)
			# these are not necessarily in order, so we need to see what name of the class wass
			if s == 'Rally Novice A':
				localFile = open(showRallyNovAFile, 'w')
			elif s == 'Rally Novice B':
				localFile = open(showRallyNovBFile, 'w')
			elif s == 'Rally Advanced A':
				localFile = open(showRallyAdvAFile, 'w')
			elif s == 'Rally Advanced B':
				localFile = open(showRallyAdvBFile, 'w')
			elif s == 'Rally Excellent A':
				localFile = open(showRallyExAFile, 'w')
			elif s == 'Rally Excellent B':
				localFile = open(showRallyExBFile, 'w')
			classFileResult = stubbornDownload(classUrl)
			if not classFileResult:
				errorLog('Could not download %s\n'%(classUrl))
			else:
				localFile.write(classFileResult)
		except AttributeError:
			# something went wrong with parsing, log it and move on
			errorLog('Something wrong with parsing file %s\n'%(showFile))
	alldone = open(doneFile, 'w')
	
	
##################################################################
# Download the main and results for show with a given id and put them 
# the appropriately named file in dumpdir.
##################################################################
def downloadPagesForShow(sid, dumpdir):
	# if we can't make the output directory, we should quit, so don't catch the exception
	dirname = '%s/%s'%(dumpdir, sid)
	if (not os.path.exists(dirname)):
		os.makedirs(dirname)

	showUrl = 'http://www.akc.org/events/search/index_results.cfm?action=event_info&comp_type=RLY&status=RSLT&event_number=%s&cde_comp_group=CONF&cde_comp_type=O&NEW_END_DATE1=&key_stkhldr_event=&mixed_breed=N'%(sid)
	showFile = '%s/%s/main.html'%(dumpdir, sid)


	print 'Getting results for %s. Dumping pages to %s'%(showUrl, dirname)
	doneFile = '%s/%s/.done'%(dumpdir, sid)

	if os.path.exists(doneFile):
		print "%s is already done, skipping"%(sid)
		return

	showResult = stubbornDownload(showUrl)
	if not showResult:
		errorLog("Could not download %s\n"%(showUrl))
	else:
		localFile = open(showFile, 'w')
		localFile.write(showResult)
		localFile.close()
		downloadClassPagesForShow(showFile, sid, dumpdir)
		
		
		
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
			

##########################################################
# Go through a directory and parse all the results files found in it
##########################################################			
def parseResultsDir(dumpdir):
	classes = ['RNA', 'RNB', 'RAA', 'RAB', 'REA', 'REB']
	for c in classes:
		infile = "%s/%s.html"%(dumpdir, c)
		outfile = "%s/%s.txt"%(dumpdir, c)
		# check if the file exists
		if os.path.exists(infile):
			parseResults(infile, outfile)