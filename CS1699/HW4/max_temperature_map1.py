#!/usr/bin/env python

import re
import sys

for line in sys.stdin:
  val = line.strip()
  (station_date, temp, q) = (val[4:23], val[87:92], val[92:93])
  if (temp != "+9999" and re.match("[01459]", q)):
    print "%s\t%s" % (station_date, temp)
