require 'csv'
require 'roo'

class DataImporter

  def self.contains_extension(path, ext)
    ext.in? File.extname(path)
  end

  def self.import file
    contents = nil
    if !(file.respond_to? :path) || !(file.respond_to? :read)
      file = File.new(file)
    end

    if contains_extension(file.path, 'xls')
      contents = Roo::Spreadsheet.open(file.path)
    else
      contents = CSV.parse(file.read)
    end

    contents.each do |row|
      next if !is_valid(row)
      import_row(row)
    end
  end

  def self.is_valid row
    raise 'unimplemented'
  end

  def self.import_row row
    raise 'unimplemented'
  end
end