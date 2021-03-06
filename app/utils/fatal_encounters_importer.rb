require 'csv'

class FatalEncountersImporter < DataImporter

  def self.is_header row
    row[0] == 'Timestamp'
  end

  def self.expected_column_count
    return 23
  end

  def self.import_row row
    date = row[6]
    unless date.is_a? Date
      date = Date.parse(date)
    end
    params = {
        :victim_name => row[1],
        :victim_age => row[2],
        :victim_gender => row[3],
        :victim_race => parse_race(row[4]),
        :victim_image_url => row[5],
        :incident_date => date,
        :incident_street_address => row[7],
        :incident_city => row[8],
        :incident_state => row[9],
        :incident_zip => input_as_integer(row[10]),
        :incident_county => row[11],
        :agency_responsible => row[12],
        :cause_of_death => row[13],
        :incident_description => row[14],
        :official_disposition_of_death => row[15],
        :news_url => row[16],
        :mental_illness => row[17]
        # don't import unique ID - we are assigning our own unique IDs instead
    }
    duplicate_entries = Incident.where(:victim_name => row[1], :incident_date => date-3.days..date+3.days)
    if duplicate_entries.count > 0
      original = duplicate_entries.first
      params.each do |key, value|
        if original[key].nil?
          original.update_attribute(key, value)
        end
      end
    else
      Incident.create!(params)
    end

  end

  def self.parse_race input
    # “Subject’s race” gets translated as follows:
    # “European-American/White” -> White
    # “African-American/Black” -> Black
    # “Hispanic/Latino” -> Hispanic
    # “Native American/Alaskan” -> Native American
    # “Unknown” -> Unknown Race
    # “Asian/Pacific Islander” -> remains as is

    if input == 'European-American/White'
      'White'
    elsif input == 'African-American/Black'
      'Black'
    elsif input == 'Hispanic/Latino'
      'Hispanic'
    elsif input == 'Native American/Alaskan'
      'Native American'
    elsif input == 'Unknown race' || input.nil? || input.empty?
      'Unknown Race'
    else
      # todo: source of truth for race categories. some entries say asian, some say asian/pacific islander
      input
    end
  end
end