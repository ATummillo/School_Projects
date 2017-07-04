#!/usr/bin/env python

import sys

total = 0
count = 0
last_key = None
for line in sys.stdin:
    (key, val) = line.strip().split("\t")
    if last_key and last_key != key:
        if count == 0:
            mean = val
        else:
            mean = total/count
        print "%s\t%s" % (last_key, mean)
        last_key = key
        count = 1
        total = int(val)
    else:
        last_key = key
        total += int(val)
        count += 1

if last_key:
    if count == 0:
        mean = val
    else:
        mean = total/count
    print "%s\t%s" % (last_key, mean)
