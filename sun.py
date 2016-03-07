#!/usr/bin/python

import os
import urllib2
import json
import time
import datetime

# Set timezone to The Netherlands
os.environ['TZ'] = 'Europe/Amsterdam'
# Europe/Rotterdam
latitude = "51"
longitude = "4"

def getDatetime(var):
        var = datetime.datetime.strptime(var, "%I:%M:%S %p")

        today = datetime.date.today()
        var = var.replace(today.year, today.month, today.day)

        if time.daylight == 1:
                var = var + datetime.timedelta(hours=1)

        return var


url = 'http://api.sunrise-sunset.org' + \
        '/json' + \
        '?lat=' + latitude + \
        '&lng=' + longitude + \
        '&date=today'
result = urllib2.urlopen(url).read()
parsed_json = json.loads(result)
sunrise = getDatetime(parsed_json['results']['sunrise'])
sunset  = getDatetime(parsed_json['results']['sunset'])

print sunrise.time(), '|', sunset.time()
