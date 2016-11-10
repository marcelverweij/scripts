#!/usr/bin/python

import urllib2
import string
import sys

# Standaard GPS locatie gebruiken
latitude = "51"
longitude = "4"

# Aangepaste GPS locatie gebruiken
if len(sys.argv[1]) != "":
	latitude = str(sys.argv[1])
if len(sys.argv[2]) != "":
	longitude = str(sys.argv[2])

url = 'http://gps.buienradar.nl/' + \
	'getrr.php' + \
	'?lat=' + latitude + \
	'&lon=' + longitude

def mm_per_uur(var):
	# mm/per uur = 10 ^ ((waarde - 109) / 32)
	if int(var) == 0:
		return 0
	return float(pow(10, ((int(var) - 109) / 32)))

result = urllib2.urlopen(url).read()
data = string.split(result, "\r\n")
for row in data:
	if row != '':
		row = string.split(row, '|')
		print row[1] + ' | ' + str(mm_per_uur(row[0])).rjust(5, ' ') + ' mm/u'
