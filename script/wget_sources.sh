#!/bin/sh

cd $(dirname $0)
cd ..

wget http://spaceflightnow.com/tracking/index.html -q -O tmp/index.html
wget http://www.nasa.gov/directorates/heo/reports/iss_reports/ -q -O tmp/issstatusreport.html

