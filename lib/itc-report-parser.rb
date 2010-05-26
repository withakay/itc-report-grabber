require 'rubygems'

class ItcReportParser
  
  def parse(filename)
    first_row = true
    column_names = []
    rows = []
    File.open(filename).each do |record|
      if first_row
        column_names = get_column_names(filename)
        first_row = false
      else
        count = 0
        row = {}
        record.split("\t").each do |field|
          field.chomp!
          row[column_names[count]] = field
          count += 1
        end
        rows.push(row)
      end
    end
    rows
  end
  
  def get_column_names(filename)
    column_names = []
    File.open(filename).each do |record|
      record.split("\t").each do |field|
        field.chomp!
        # do something here with each field
        column_names.push field.gsub("/", "_").gsub(" ", "_").gsub("___", "_").downcase
      end
      break   
    end
    p column_names
    column_names
  end
  
end