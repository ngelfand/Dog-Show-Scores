# Functions for dealing with judges

import urllib2
from BeautifulSoup import BeautifulSoup
import re
import sys
import os

TIMEOUT = 15
NUMTRIES = 10

##################################################################
##################################################################
# Utility Functions
##################################################################
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
	
#
# Download a list of judges from infodog and write the
# results to a file called judges.txt
#
def getJudgesFromInfodog():
	urlNovice = 'http://www.infodog.com/judges/jdd93100.htm'
	urlOpen = 'http://www.infodog.com/judges/jdd93200.htm'
	urlUtility = 'http://www.infodog.com/judges/jdd93300.htm'

	judges = {}

	# parse out judge's ID
	prog = re.compile("([0-9]+)")
	for url in (urlNovice, urlOpen, urlUtility):
		print 'Processing %s'%(url)
		soup = BeautifulSoup(urllib2.urlopen(url))
		table = soup.findAll('table')[1]
		rows = table.findAll('tr')
		for row in rows:
			cols = row.findAll('td')
			if (len(cols) == 2):
				link = cols[0].a['href']
				m = prog.search(link)
				jid = m.group(1)
				jname = cols[0].a.string.strip()
				if (judges.has_key(jid) and judges[jid] != jname):
					print 'Judge id %d has two different names %s and %s'&(jid, judges[jid], jname)
				judges[jid] = jname
			
	print 'Found %d judges'%(len(judges))

	f = open('judges.txt', 'w')
	for k, v in judges.iteritems():
		f.write('%s; %s\n'%(k,v))
	f.close()
	
	
#
# Parse a list of obedience judges downloaded from AKC and
# append the judge id and name.
#
def parseAkcJudgeList(inFilename, outFilename):
	infile = open(inFilename, 'r')
	outfile = open(outFilename, 'a')
	soup = BeautifulSoup(infile)
	names = []
	numbers = []
	judges = soup.findAll(id='judge_name')
	for j in judges:
		name = j.contents[0].strip()
		name = name.strip('&nbsp;')
		name = name.strip()
		names.append(name)
	ids = soup.findAll(text="Judge's Number:")
	for i in ids:
		number = i.parent.nextSibling.strip()
		numbers.append(number)
	
	if (len(names) != len(numbers)):
		print "Failed getting judges from %s, got %d names and %d numbers."%(inFilename, len(names), len(numbers))
		
	for i in range(len(names)):
		string = "%s; %s\n"%(numbers[i], names[i])
		print string.strip()
		outfile.write(string)
		
		
def downloadShowsForJudge(jid, dumpdir):
	outfileName = "%s/%s.txt"%(dumpdir, jid)
	if os.path.exists(outfileName):
		print "Already done"
		return
		
	url = "http://www.akc.org/judges_directory/index.cfm?action=refresh_index&active_tab_row=1&active_tab_col=3&fixed_tab=3&judge_id=%s"%(jid)
	fileContents = stubbornDownload(url)
	print fileContents
	soup = BeautifulSoup(fileContents)
	events = set()
	# this one is easy, parse out everything that has event_number and OBED in it
	# because AKC writes the even number like a zillion times, we'll do a set
	event_prog = re.compile('event_number=([0-9]+)')
	for event in soup.findAll(href = re.compile('/events/search/index_results.cfm\?action=plan&event_number=[0-9]*&cde_comp_group=RLY')):
		#print event['href']
		m = event_prog.search(event['href'])
		event_id = m.group(1)
		events.add(event_id)
		
	# write out the events
	outFile = open(outfileName, 'w')
	for e in events:
		outFile.write("%s\n"%(e))
		
		
def downloadShowsForJudgeFile(infile, outfile):
	soup = BeautifulSoup(open(infile, 'r'))
	events = set()
	# this one is easy, parse out everything that has event_number and OBED in it
	# because AKC writes the even number like a zillion times, we'll do a set
	event_prog = re.compile('event_number=([0-9]+)')
	for event in soup.findAll(href = re.compile('/events/search/index_results.cfm\?action=plan&event_number=[0-9]*&cde_comp_group=OBED')):
		#print event['href']
		m = event_prog.search(event['href'])
		event_id = m.group(1)
		events.add(event_id)

	# write out the events
	out = open(outfile, 'w')
	for e in events:
		out.write("%s\n"%(e))
		
#
# Given a list of judge id's in a file (plus other info generated by the above function
# that we'll ignore), download the list of shows the given judge judged (in obedience|rally|agility)
# get that show's information and write it to a file. We don't need anything besides the show id
# because our obedience functions take care of the rest.
#
def downloadShowsForJudges(judgeFileName, dumpdir):
	print judgeFileName
	judgeFile = open(judgeFileName, 'r')
	for line in judgeFile:
		line = line.rstrip()
		jid, jname = line.split('; ')
		jid = jid.strip()
		jname = jname.strip()
		print "Processing judge %s, %s"%(jid, jname)
		downloadShowsForJudge(jid, dumpdir)
		
if __name__ == '__main__':
	downloadShowsForJudge(sys.argv[1], sys.argv[2])