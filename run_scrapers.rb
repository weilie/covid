#!/usr/bin/env ruby
require 'date'
cmd = "/Users/weilie/code/personal/covid19/scrape_sd.rb > /Users/weilie/code/personal/covid19/snapshots/sd.snapshot.#{DateTime.now.strftime("%Y%m%dT%H%M%S%z")} 2>> /Users/weilie/code/personal/covid19/err.scrapers"
system cmd
cmd = "/usr/local/bin/wget https://www.sandiegocounty.gov/content/dam/sdc/hhsa/programs/phs/Epidemiology/COVID-19%20City%20of%20Residence_MAP.pdf -O /Users/weilie/code/personal/covid19/snapshots/sd.cities.map.#{DateTime.now.strftime("%Y%m%dT%H%M")}.pdf 2> /Users/weilie/code/personal/covid19/err.wget"
system cmd
cmd = "/usr/local/bin/wget https://www.sandiegocounty.gov/content/dam/sdc/hhsa/programs/phs/Epidemiology/COVID-19%20Summary%20of%20Cases%20by%20Zip%20Code.pdf -O /Users/weilie/code/personal/covid19/snapshots/sd.zip.code.#{DateTime.now.strftime("%Y%m%dT%H%M")}.pdf 2> /Users/weilie/code/personal/covid19/err.wget"
system cmd
cmd = "/usr/local/bin/wget https://www.sandiegocounty.gov/content/dam/sdc/hhsa/programs/phs/Epidemiology/COVID-19%20Daily%20Update_City%20of%20Residence.pdf -O /Users/weilie/code/personal/covid19/snapshots/sd.cities.table.#{DateTime.now.strftime("%Y%m%dT%H%M")}.pdf 2> /Users/weilie/code/personal/covid19/err.wget"
system cmd
cmd = "/usr/local/bin/wget https://covid.cdc.gov/covid-data-tracker/COVIDData/getAjaxData?id=vaccination_data -O /Users/weilie/code/personal/covid19/snapshots/cdc.#{DateTime.now.strftime("%Y%m%dT%H%M")}.json 2> /Users/weilie/code/personal/covid19/err.wget"
system cmd
