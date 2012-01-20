import os
import sys
from BeautifulSoup import BeautifulSoup
import re
import urllib2
import time
import datetime
import socket
socket.setdefaulttimeout(300)

TIMEOUT = 15
NUMTRIES = 10

##################################################################
##################################################################
# Utility Functions
##################################################################
##################################################################


##################################################################
# Parse an AKC monthly results calendar and extract a list of
# shows out of it. Return the list of shows.
##################################################################
def extractShowIds(inname):
	infile = open(inname, 'r')	
	showlist = []
	soup = BeautifulSoup(infile)
	# all we care about are the even id's
	# we want the lines that look like this: 
	# <div align="center"><strong>Event Number: </strong> 2011025109</div>
	for s in soup.findAll(text=re.compile('Event Number: ')):
		try:
			show_id =  s.parent.nextSibling.strip()
			showlist.append(show_id)
		except AttributeError:
			continue			
	return showlist
	

##################################################################
# Write an error string to a file
##################################################################	
def errorLog(string):
	errorFile = open('errors.txt', 'a')
	errorFile.write(string)
	errorFile.close()
	

##################################################################
# Download with a whole bunch of retries. Keep downloading until
# we either get the file, or number of retries is exceeded.
# Returns the contents or false when download really fails.
##################################################################
def stubbornDownload(url, numtries = NUMTRIES, timeout=TIMEOUT):
	tries = 0
	while tries < numtries:
		try:
			result = urllib2.urlopen(url, timeout=timeout).read()
			return result
		except urllib2.URLError, e:
			errorLog('Could not download %s because %s retrying %d\n'%(url, e.reason, tries))
			tries += 1
		except socket.error, e:
			errorLog('Timed out downloading %s retrying %d\n'%(url, tries))
			tries += 1
	return false
	
	
##########################################################
# Parse a results file (NA.html for example) and save results
# in a txt file (NA.txt for the above example)
##########################################################
def parseResults(inName, outName):
	print 'Parsing', inName
	inFile = open(inName, 'r')
	outFile = open(outName, 'w')

	prog_pts = re.compile("([0-9\.]+)")
	prog_own = re.compile("^&nbsp;(.*)")
	prog_akc = re.compile('([A-Z]{0,3}[0-9]+)')
	soup = BeautifulSoup(inFile)
	# find everything that refers to the AKC store
	for s in soup.findAll(href=re.compile('/store/reports/index')):
		# if anything goes wrong with parsing, just return
		try:
			akc = s['href']
			name = s.contents[0].strip()
			breed = s.nextSibling.nextSibling.contents[0].strip()
			owner = s.nextSibling.nextSibling.nextSibling.strip()
			points = s.parent.parent.nextSibling.nextSibling.contents[1].contents[0].strip()
		except AttributeError as e:
			print e
			continue

		# now clean them up, remove all &nbsp from the owner name
		# and remove the pts from the points
		#print "==="
		#print akc
		#print name
		#print breed
		#print owner
		#print points
		#print "==="

		m = prog_own.search(owner)
		owner = m.group(1)
		#print "Owner: [%s]"%(owner)

		m = prog_pts.search(points)
		points = m.group(1)
		#print "Points: [%s]"%(points)


		m = prog_akc.search(akc)
		akc = m.group(1)
		#print "AKC: [%s]"%(akc)

		#print "Name: [%s]"%(name)
		#print "Breed: [%s]"%(breed)
		outFile.write("%s;%s;%s;%s;%s\n"%(akc,name.encode('ascii', 'ignore'),breed,owner.encode('ascii', 'ignore'),points))
	outFile.close()
