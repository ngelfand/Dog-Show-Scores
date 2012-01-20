import urllib
import urllib2
from common_utils import *
import sys
import socket
from BeautifulSoup import BeautifulSoup

	
#
# Download updated names for AKC id's
#

def download_name(dog_id):
	url = 'https://www.akc.org/store/reports/dog/search/dog_search.cfm?button=search&RequestTimeout=300&report_cde=CMPREC&report_category_cde='
	values = {'returnpage' : '/store/reports/dog/index.cfm?report_category_cde=DOG?external=yes&report_cde=CMPREC',
		   'dogsearch_view' : 'search',
		   'search_type' : 'id',
		   'search_dog_id' : dog_id }
	data = urllib.urlencode(values)
	req = urllib2.Request(url, data)
	the_page = stubbornDownload(req)
	return the_page
	
	
def parse_name_page(the_page):
	soup = BeautifulSoup(the_page)
	name = soup.findAll('td', attrs={'class' : 'tbltxt'})[4].string
	return name

def get_name(dog_id):
	page = download_name(dog_id)
	name = parse_name_page(page)
	return name
	
if __name__ == '__main__':
	if sys.argv[1] == '-d':
		dog_id = sys.argv[2]
		name = get_name(dog_id)
		if name is None:
			print "Oops"
		print "%s; %s"%(dog_id, name)
	else:
		dogfilename = sys.argv[1]
		outfilename = sys.argv[2]
		dogfile = open(dogfilename, 'r')
		outfile = open(outfilename, 'w')
		for line in dogfile:
			line = line.strip()
			(akc_id, oldname) = line.split('; ')
			newname = get_name(akc_id)
			if newname is None:
				newname = oldname
			#print ("%s; %s; %s"%(akc_id, oldname, newname.encode('ascii', 'ignore')))
			outfile.write("%s; %s; %s\n"%(akc_id, oldname, newname.encode('ascii', 'ignore')))