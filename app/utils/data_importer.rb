require 'csv'
require 'roo'

class DataImporter

  # fields that contain numeric values in XLSX files are represented internally as floats
  # (regardless of the cell's number format), so when they are implicitly converted to string,
  # they have a trailing decimal (e.g. 94608.0 for a zip code)
  def self.input_as_integer(zip)
    if zip.nil? then nil else zip.to_i end
  end

  def self.contains_extension(path, ext)
    ext.in? File.extname(path)
  end

  def self.import(file)
    contents = nil
    if !(file.respond_to? :path) || !(file.respond_to? :read)
      file = File.new(file)
    end

    if contains_extension(file.path, 'xls')
      contents = Roo::Spreadsheet.open(file.path)
    else
      contents = CSV.parse(file.read)
    end

    import_rows contents
  end

  def self.import_rows(contents)
    contents.each_with_index do |row, index|
      next if !is_valid(row, index)
      import_row(row)
    end
  end

  def self.is_valid(row, index)
    if row.nil? || row.count == 0 || is_header(row)
      return false
    end

    if row.count != expected_column_count
      raise "This file does not have the expected number of columns at row #{index}
          (expected: #{expected_column_count}, actual: #{row.count})"
    end

    return true
  end

  def self.is_header(row)
    raise 'unimplemented'
  end

  def self.import_row(row)
    raise 'unimplemented'
  end

  def self.expected_column_count
    raise 'unimplemented'
  end
end