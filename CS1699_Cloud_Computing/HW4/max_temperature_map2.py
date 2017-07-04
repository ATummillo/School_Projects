#!/usr/bin/env python

import re
import sys

for line in sys.stdin:
    (val1, val2) = line.strip().split("\t")
    (station, date_month_day) = (val1[0:11], val1[15:19])

    print "%s%s\t%s" % (station, date_month_day, val2)
