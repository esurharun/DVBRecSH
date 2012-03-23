#!/bin/bash

df -h /disk1/ | awk '{ if ($5 != "Use%") { if (int(substr($5,0,length($5)))>=99) { system("/opt/recserver/removeoldest.sh " $6) } } }'
df -h /disk2/ | awk '{ if ($5 != "Use%") { if (int(substr($5,0,length($5)))>=99) { system("/opt/recserver/removeoldest.sh " $6) } } }'
