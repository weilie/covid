#!/usr/bin/env ruby
require 'date'
require 'json'
table = {}
Dir.glob("snapshots/cdc.*.json").sort.each do |file|
  STDERR.puts file
  r = JSON.parse(File.read(file))
  r["vaccination_data"].each do |x|
    date = x["Date"]
    table[date] ||= {}
    next unless x["Census2019"] && x["Census2019"] > 165768 && x["Location"] != "US" # skip non states
    table[date][x["Location"]] = {
                                 "Doses_Distributed" => x["Doses_Distributed"],
                                 "Doses_Administered" => x["Doses_Administered"],
                                 "Administered_Dose1" => x["Administered_Dose1"] || (x['Doses_Administered'] - x['Administered_Dose2_Recip']), 
                                 "Administered_Dose2" => x["Administered_Dose2"] || x['Administered_Dose2_Recip'], 
                                 "Population" => x["Census2019"]
                                 }
  end
end
states = table.values.map{|x| x.keys}.flatten.uniq.sort.select{|x| x.size == 2}
File.open("vac_cdc_curve_population.tsv", "w") do |file|
  file.puts ["Date", states] * "\t"
  table.sort_by{|date, x| date}.reverse.each do |date, x|
    file.puts [date, states.map{|state| x[state]["Administered_Dose1"] / x[state]["Population"].to_f}] * "\t"
  end
end
File.open("vac_cdc_curve_doses.tsv", "w") do |file|
  file.puts ["Date", states] * "\t"
  table.sort_by{|date, x| date}.reverse.each do |date, x|
    file.puts [date, states.map{|state| x[state]["Doses_Administered"]}] * "\t"
  end
end
File.open("vac_cdc_now.tsv", "w") do |file|
  file.puts ["State", "Population", "Doses_Distributed", "Doses_Administered", "Administered_Dose1", "Administered_Dose2"] * "\t"
  date, states = table.sort_by{|date, x| date}.last 
  states.select{|x| x.size == 2}.each do |k,v|
    file.puts [k, v["Population"], v["Doses_Distributed"], v["Doses_Administered"], v["Administered_Dose1"], v["Administered_Dose2"]] * "\t"
  end
end
=begin
{
  "runid": 1812,
  "vaccination_data": [
    {
      "Date": "2021-01-19",
      "Location": "AK",
      "ShortName": "AKA",
      "LongName": "Alaska",
      "Census2019": 731545,
      "Doses_Distributed": 150450,
      "Doses_Administered": 66331,
      "Dist_Per_100K": 20566,
      "Admin_Per_100K": 9067,
      "Administered_Dose1": 55434,
      "Administered_Dose1_Per_100K": 7578,
      "Administered_Dose2": 10802,
      "Administered_Dose2_Per_100K": 1477
    },

=end
