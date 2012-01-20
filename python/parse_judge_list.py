#
# Parse the juedges list downloaded from AKC.
# For each judge, get their name, address, and AKC number.
# Write the results into a file.
#

import sys
import judges

judges.parseAkcJudgeList(sys.argv[1], sys.argv[2])



