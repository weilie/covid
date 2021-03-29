#!/usr/bin/env ruby
require "csv"
state_counters = {}
country_counters = {}

def state_normalization name
  state_mapping = {"Alabama" => "AL", "Alaska" => "AK", "Arizona" => "AZ", "Arkansas" => "AR", "California" => "CA", "Colorado" => "CO", "Connecticut" => "CT", "Delaware" => "DE", "Florida" => "FL", "Georgia" => "GA", "Hawaii" => "HI", "Idaho" => "ID", "Illinois" => "IL", "Indiana" => "IN", "Iowa" => "IA", "Kansas" => "KS", "Kentucky" => "KY", "Louisiana" => "LA", "Maine" => "ME", "Maryland" => "MD", "Massachusetts" => "MA", "Michigan" => "MI", "Minnesota" => "MN", "Mississippi" => "MS", "Missouri" => "MO", "Montana" => "MT", "Nebraska" => "NE", "Nevada" => "NV", "New Hampshire" => "NH", "New Jersey" => "NJ", "New Mexico" => "NM", "New York" => "NY", "North Carolina" => "NC", "North Dakota" => "ND", "Ohio" => "OH", "Oklahoma" => "OK", "Oregon" => "OR", "Pennsylvania" => "PA", "Rhode Island" => "RI", "South Carolina" => "SC", "South Dakota" => "SD", "Tennessee" => "TN", "Texas" => "TX", "Utah" => "UT", "Vermont" => "VT", "Virginia" => "VA", "Washington" => "WA", "West Virginia" => "WV", "Wisconsin" => "WI", "Wyoming" => "WY", "District of Columbia" => "DC", "Washington, D.C." => "DC", "Puerto Rico" => "PR", "American Samoa" => "AS", "Virgin Islands" => "VI", "Virgin Islands, U.S." => "VI", "United States Virgin Islands" => "VI", "Guam" => "GU", "Northern Mariana Islands" => "MP"}
  if name =~ /^[A-Z]{2}$/
    name
  elsif name =~ /, ([A-Z]{2})\b/
    $1
  else
    STDERR.puts "unknown state name #{name}" unless state_mapping[name]
    state_mapping[name]
  end
end

def country_normalization name
  if name == 'Iran (Islamic Republic of)'
    "Iran"
  elsif name == "Korea, South" || name == "Republic of Korea"
    "South Korea"
  elsif name == "Hong Kong SAR"
    "Hong Kong"
  elsif name == "Republic of Ireland"
    "Ireland"
  else
    name
  end
end

Dir.glob("data/csse_covid_19_data/csse_covid_19_daily_reports/*.csv").sort_by{|x| a = x.split('/').last.split(/[\-\.]/); [a[2], a[0], a[1]]}.each do |file|
  next unless file =~ /(.{10}).csv/
  date = $1
  STDERR.puts date
  state_counters[date] ||= Hash.new(0)
  country_counters[date] ||= Hash.new(0)
  CSV.foreach(file, headers: true, encoding: 'bom|utf-8') do |row|
    if row['Country/Region']
      country = country_normalization(row['Country/Region'])
      next if country == 'Russian Federation'
      country_counters[date][country] += row['Confirmed'].to_i
    elsif row['Country_Region']
      country = country_normalization(row['Country_Region'])
      next if country == 'Russian Federation'
      country_counters[date][country] += row['Confirmed'].to_i
    end
    if row['Country/Region'] == 'US'
      state = state_normalization(row["Province/State"])
      if state.nil?
        STDERR.puts row["Province/State"]
        next
      else
        state_counters[date][state] += row['Confirmed'].to_i
      end
    elsif row['Country_Region'] == 'US'
      state = state_normalization(row['Province_State'])
      if state.nil?
        STDERR.puts row['Province_State']
        next
      else
        state_counters[date][state] += row['Confirmed'].to_i
      end
    end
  end
end

all_dates = state_counters.keys.sort_by{|x| a = x.split(/[\-\.]/); [a[2], a[0], a[1]]}.reverse
all_states = state_counters.values.map{|x| x.keys}.flatten.sort.uniq
File.open("states.tsv", "w") do |file|
  file.puts ["Date", all_states] * "\t"
  all_dates.each do |date|
    file.puts [date, all_states.map{|state| state_counters[date][state] || 0}] * "\t"
  end
end
all_countries = country_counters.values.map{|x| x.keys}.flatten.sort.uniq
File.open("countries.tsv", "w") do |file|
  file.puts ["Date", all_countries] * "\t"
  all_dates.each do |date|
    file.puts [date, all_countries.map{|country| country_counters[date][country] || 0}] * "\t"
  end
end

county_counters = {}

Dir.glob("data/csse_covid_19_data/csse_covid_19_daily_reports/*.csv").sort_by{|x| a = x.split('/').last.split(/[\-\.]/); [a[2], a[0], a[1]]}.each do |file|
  next unless file =~ /(.{10}).csv/
  date = $1
  STDERR.puts date
  county_counters[date] ||= Hash.new(0)
  CSV.foreach(file, headers: true, encoding: 'bom|utf-8') do |row|
    next unless row['Province_State'] == 'California'
    if row['Admin2']
      county = row['Admin2']
      county_counters[date][county] += row['Confirmed'].to_i
    end
  end
end
all_dates = county_counters.keys.sort_by{|x| a = x.split('/').last.split(/[\-\.]/); [a[2], a[0], a[1]]}.reverse
all_counties = county_counters.values.map{|x| x.keys}.flatten.sort.uniq
File.open("counties.tsv", "w") do |file|
  file.puts ["Date", all_counties] * "\t"
  all_dates.each do |date|
    file.puts [date, all_counties.map{|county| county_counters[date][county] || 0}] * "\t"
  end
end
