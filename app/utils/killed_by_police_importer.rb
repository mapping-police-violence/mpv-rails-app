require 'csv'

class KilledByPoliceImporter < DataImporter

  def self.is_valid(row)
    # whatever the dumb unlabeled column is, it's only present in valid rows
    # so, check for the presence of that
    !row[4].nil? && !row[4].empty?
  end

  def self.import_row(row)
    parsed_data = {}
    # This source csv has an *interesting* design.
    # There are several values jammed into some columns, comma or dash delimited.
    # Some values jammed into the columns may or may not be present.
    # soooo, let's parse this data into clean key/value pairs before we create this incident.
    race_and_gender = parse_race_and_gender(row[2])
    parsed_data.merge!(race_and_gender)
    name_and_age = parse_name_and_age(row[3])
    parsed_data.merge!(name_and_age)

    incident = Incident.create!({
                         :incident_date => parse_date(row[0]),
                         :incident_state => row[1],
                         :victim_gender => parsed_data[:gender],
                         :victim_race => parsed_data[:race],
                         :victim_name => parsed_data[:name],
                         :victim_age => parsed_data[:age],
                         :victim_image_url => parsed_data[:image_link],
                         :news_url => parse_news_url(row[6])
                     })
  end

  def self.parse_date input
    # “date” gets translated as follows:
    # (956) October 20, 2015 turns into an actual date object representing October 20, 2015
    parsed_date = nil
    if input != nil
      parsed_date = input.gsub /\(\d*\)/, ''
    end
    parsed_date.split('\r?\n')[0]
  end

  def self.parse_name_and_age(input)
    # input is in the format 'name, age' or ',age' if name is missing
    # also may include an image URL if it's a Roo::Link
    parsed_input = {}
    # TODO: learn the idiomatic way of checking if input has the href attribute, rather
    # than explicitly checking the class
    if input.class == Roo::Link
      parsed_input[:image_link] = input.href
    end
    unless input.nil?
      split_input = input.split(',')
      unless split_input[0].empty?
        parsed_input[:name] = split_input[0]
      end
      unless split_input[1].empty?
        parsed_input[:age] = split_input[1]
      end
    end
    parsed_input
  end



  def self.parse_race_and_gender(input)
    # input is translated as follows:
    # M -> “Male”
    # F -> “Female”
    # /B -> “Black”
    # /W -> “White”
    # /L -> “Hispanic”
    # /I -> “Native American”
    # /A -> “Asian”
    # /O -> “Unknown race”
    # (no / or letter) -> “Unknown race”
    # sometimes, inputs are in the format 'M/B'
    # sometimes, they're in the format 'M'
    # returns a dict with whatever data is present
    if input == nil
      return {}
    end
    parsed_data = {}
    if input.length == 1
      parsed_data[:gender] = parse_gender(input)

    else
      split_input = input.split('/')
      parsed_data[:gender] = parse_gender(split_input[0])
      parsed_data[:race] = parse_race(split_input[1])
    end
    parsed_data
  end

  def self.parse_gender(input)
    gender = ''
    # because women come first, dammit
    if input == 'F'
      gender = 'Female'
    else
      gender = 'Male'
    end
  end

  def self.parse_race(input)
    race = ''
    if input == 'B'
      race = 'Black'
    elsif input == 'A'
      race = 'Asian'
    elsif input == 'W'
      race = 'White'
    elsif input == 'L'
      race = 'Hispanic'
    elsif input == 'I'
      race = 'Native American'
    else
      race = 'Unknown Race'
    end
  end

  def self.parse_news_url(input)
    URI.parse(input.split[0])
  end
end
