#!/bin/sh

cd $(dirname $0)
cd ..

wget http://spaceflightnow.com/tracking/index.html -q -O tmp/temp.html
if [ $? -eq 0 ]; then
  mv tmp/temp.html tmp/index.html
fi

wget http://www.nasa.gov/directorates/heo/reports/iss_reports/ -q -O tmp/temp.html
if [ $? -eq 0 ]; then
  mv tmp/temp.html tmp/issstatusreport.html
fi
