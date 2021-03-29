#!/usr/bin/env ruby
require 'open-uri'
require 'json'
require 'time'
require 'date'

doc = JSON.parse(URI.open("https://services1.arcgis.com/1vIhDJwtG5eNmiqX/arcgis/rest/services/CovidDashUpdate/FeatureServer/1/query?f=json&where=Date>=timestamp '2020-03-26 07:00:00'&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=Date asc&outSR=102100&resultOffset=0&resultRecordCount=32000&resultType=standard&cacheHint=true").read)

File.open("sd_county.tsv", "w") do |file|
  file.puts ["Date", "Tests", "Positives", "Hospitalized", "ICU", "Deaths", "New Tests", "New Cases", "Rolling % +", "Age_9", "Age10_19", "Age20_29", "Age30_39", "Age40_49", "Age50_59", "Age60_69", "Age70_79", "Age80_Plus", "AgeUnknow"] * "\t"
  doc["features"].sort_by{|f| f["attributes"]["Date"]}.reverse.each do |f|
    a = f["attributes"]
    file.puts [Time.at(a["Date"] / 1000).to_date, a["Tests"], a["Positives"], a["Hospitalized"], a["ICU"], a["Deaths"], a["NewTests"], a["NewCases"], a["Rolling_Perc_Pos_Cases"], a["Age_9"], a["Age10_19"], a["Age20_29"], a["Age30_39"], a["Age40_49"], a["Age50_59"], a["Age60_69"], a["Age70_79"], a["Age80_Plus"], a["AgeUnknow"]] * "\t"
  end
end

# {"attributes"=>{"OBJECTID"=>16, "Date"=>1585209600000, "Tests"=>6078, "Positives"=>417, "Hospitalized"=>85, "ICU"=>38, "Deaths"=>5, "NewCases"=>76, "Age_9"=>3, "Age10_19"=>4, "Age40_49"=>73, "Age50_59"=>65, "Age60_69"=>31, "Age70_79"=>29, "Age80_Plus"=>20, "AgeUnknow"=>2, "Age20_29"=>84, "GenderFemale"=>166, "GenderMale"=>249, "GendeUnk"=>1, "NewTests"=>1023, "Age30_39"=>106, "Rolling_Perc_Pos_Cases"=>8.21392532795156}}

doc = JSON.parse(URI.open("https://services1.arcgis.com/1vIhDJwtG5eNmiqX/arcgis/rest/services/CovidDashUpdate/FeatureServer/3/query?f=json&where=(name%20%3C%3E%20%27FEDERAL%20QUARANTINE%27)%20AND%20(lastupdate%20NOT%20BETWEEN%20timestamp%20%272020-03-24%2007:00:00%27%20AND%20timestamp%20%272020-03-25%2006:59:59%27)%20AND%20(lastupdate%20NOT%20BETWEEN%20timestamp%20%272020-03-23%2007:00:00%27%20AND%20timestamp%20%272020-03-24%2006:59:59%27)%20AND%20(lastupdate%20NOT%20BETWEEN%20timestamp%20%272020-03-22%2007:00:00%27%20AND%20timestamp%20%272020-03-23%2006:59:59%27)%20AND%20(lastupdate%20NOT%20BETWEEN%20timestamp%20%272020-03-21%2007:00:00%27%20AND%20timestamp%20%272020-03-22%2006:59:59%27)%20AND%20(lastupdate%20NOT%20BETWEEN%20timestamp%20%272020-03-20%2007:00:00%27%20AND%20timestamp%20%272020-03-21%2006:59:59%27)&returnGeometry=true&spatialRel=esriSpatialRelIntersects&geometry={%22xmin%22:-13149614.849956956,%22ymin%22:3757032.814277027,%22xmax%22:-12523442.714244962,%22ymax%22:4383204.949989023,%22spatialReference%22:{%22wkid%22:102100}}&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&outSR=102100&resultType=tile").read)

doc = JSON.parse(URI.open("https://services1.arcgis.com/1vIhDJwtG5eNmiqX/arcgis/rest/services/CovidDashUpdate/FeatureServer/3/query?f=json&where=(name%20%3C%3E%20%27FEDERAL%20QUARANTINE%27)&returnGeometry=false&spatialRel=esriSpatialRelIntersects&geometry={%22xmin%22:-13149614.849956956,%22ymin%22:3757032.814277027,%22xmax%22:-12523442.714244962,%22ymax%22:4383204.949989023,%22spatialReference%22:{%22wkid%22:102100}}&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&orderByFields=lastupdate%20DESC&outSR=102100&resultType=tile").read)
File.open("cities.tsv", "w") do |file|
  file.puts ["Date", "City", "Cases"] * "\t"
  doc["features"].each do |f|
    a = f["attributes"]
    next unless a["loctype"] == "Incorporated City"
    file.puts [Time.at(a["lastupdate"] / 1000).to_date, a["name"], a["confirmedcases"]] * "\t"
  end
end

doc = JSON.parse(URI.open("https://services1.arcgis.com/1vIhDJwtG5eNmiqX/arcgis/rest/services/CovidDashUpdate/FeatureServer/0/query?f=json&where=Case_Count%20%3E=%201&returnGeometry=false&spatialRel=esriSpatialRelIntersects&geometry={%22xmin%22:-13071343.332988407,%22ymin%22:3835304.331230441,%22xmax%22:-12993071.816024356,%22ymax%22:3913575.848194491,%22spatialReference%22:{%22wkid%22:102100}}&geometryType=esriGeometryEnvelope&inSR=102100&outFields=*&orderByFields=UpdateDate%20DESC&outSR=102100&resultType=tile").read)

File.open("zipcode.tsv", "w") do |file|
  file.puts ["Date", "Zip Code", "Cases"] * "\t"
  doc["features"].each do |f|
    a = f["attributes"]
    file.puts [Time.at(a["UpdateDate"] / 1000).to_date, a["ZipText"], a["Case_Count"]] * "\t"
  end
end

=begin
{
     "attributes": {
       "OBJECTID": 17,
       "Date": 1585296000000,
       "Tests": 6854,
       "Positives": 488,
       "Hospitalized": 96,
       "ICU": 42,
       "Deaths": 7,
       "NewCases": 71,
       "Age_9": 3,
       "Age10_19": 5,
       "Age40_49": 85,
       "Age50_59": 74,
       "Age60_69": 36,
       "Age70_79": 38,
       "Age80_Plus": 25,
       "AgeUnknow": 2,
       "Age20_29": 102,
       "GenderFemale": 206,
       "GenderMale": 280,
       "GendeUnk": 2,
       "NewTests": 776,
       "Age30_39": 118,
       "Rolling_Perc_Pos_Cases": 8.2584962141222

=end
