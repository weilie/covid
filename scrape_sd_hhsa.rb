#!/usr/bin/env ruby
require 'open-uri'
require 'json'
require 'date'

(Date.parse("2021-05-10")...(Date.today + 1)).each do |date|
  doc = JSON.parse(URI.open("https://services1.arcgis.com/1vIhDJwtG5eNmiqX/arcgis/rest/services/Vaccination_Demographics/FeatureServer/0/query?f=json&where=(Update_Date BETWEEN timestamp '#{date - 1} 07:00:00' AND timestamp '#{date} 06:59:59') AND (Catefory='AdministeredDoses')&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=[{\"statisticType\":\"sum\",\"onStatisticField\":\"Count_\",\"outStatisticFieldName\":\"value\"}]&outSR=102100&resultType=standard&cacheHint=true").read)
  puts [date, "Administered", doc["features"][0]["attributes"]["value"]] * "\t"

  if date <= Date.parse('2021-02-22')
    doc = JSON.parse(URI.open("https://services1.arcgis.com/1vIhDJwtG5eNmiqX/arcgis/rest/services/Vaccination_Demographics/FeatureServer/0/query?f=json&where=(Update_Date BETWEEN timestamp '#{date - 1} 07:00:00' AND timestamp '#{date} 06:59:59') AND (Catefory='Gender')&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=[{\"statisticType\":\"sum\",\"onStatisticField\":\"Count_\",\"outStatisticFieldName\":\"value\"}]&outSR=102100&resultType=standard&cacheHint=true").read)
  else
    doc = JSON.parse(URI.open("https://services1.arcgis.com/1vIhDJwtG5eNmiqX/arcgis/rest/services/Vaccination_Demographics/FeatureServer/0/query?f=json&where=(Update_Date BETWEEN timestamp '#{date - 1} 07:00:00' AND timestamp '#{date} 06:59:59') AND (Catefory='SDResVacc')&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=[{\"statisticType\":\"sum\",\"onStatisticField\":\"Count_\",\"outStatisticFieldName\":\"value\"}]&resultType=standard&cacheHint=true").read)
  end
  puts [date, "First Dose", doc["features"][0]["attributes"]["value"]] * "\t"

  doc = JSON.parse(URI.open("https://services1.arcgis.com/1vIhDJwtG5eNmiqX/arcgis/rest/services/Vaccination_Demographics/FeatureServer/0/query?f=json&where=(Update_Date BETWEEN timestamp '#{date - 1} 07:00:00' AND timestamp '#{date} 06:59:59') AND (Catefory='SDResFullyVacc')&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&outStatistics=[{\"statisticType\":\"sum\",\"onStatisticField\":\"Count_\",\"outStatisticFieldName\":\"value\"}]&resultType=standard&cacheHint=true").read)
  puts [date, "Fully Vaccinated", doc["features"][0]["attributes"]["value"]] * "\t"

end
