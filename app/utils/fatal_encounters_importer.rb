require 'csv'

class FatalEncountersImporter < DataImporter

  def self.is_valid row
    !row[0].nil? && row[0] != 'Timestamp'
  end

  def self.import_row row
    Incident.create!({
                         :victim_name => row[1],
                         :victim_age => row[2],
                         :victim_gender => row[3],
                         :victim_race => parse_race(row[4]),
                         :victim_image_url => row[5],
                         :incident_date => row[6],
                         :incident_street_address => row[7],
                         :incident_city => row[8],
                         :incident_state => row[9],
                         :incident_zip => row[10],
                         :incident_county => row[11],
                         :agency_responsible => row[12],
                         :cause_of_death => row[13],
                         :incident_description => row[14],
                         :official_disposition_of_death => row[15],
                         :news_url => row[16],
                         :mental_illness => row[17]
                         # don't import unique ID - we are assigning our own unique IDs instead
                     })
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