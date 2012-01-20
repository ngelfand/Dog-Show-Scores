import common_utils
import sys

outfile = open(sys.argv[2], 'w')
shows = common_utils.extractShowIds(sys.argv[1])
for show in shows:
	outfile.write("%s\n"%(show))
	