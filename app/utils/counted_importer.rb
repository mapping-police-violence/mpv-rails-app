require 'csv'

class CountedImporter < DataImporter

  def self.is_header row
    row[0] == 'name'
  end

  def self.expected_column_count
    return 13
  end

  def self.import_row row
    date = parse_date(row[4],row[5],row[6])
    duplicate_entries = Incident.where(:victim_name => row[0], :incident_date => date-3.days..date+3.days)

    params = {
        :victim_name => row[0],
        :victim_age => row[1],
        :victim_gender => row[2],
        :victim_race => parse_race(row[3]),
        :incident_date => date,
        :incident_street_address => row[7],
        :incident_city => row[8],
        :incident_state => row[9],
        :cause_of_death => row[10],
        :agency_responsible => row[11],
        :unarmed => parse_unarmed(row[12])
    }

    if duplicate_entries.count > 0
      duplicate_entries.first.update!(params)
    else
      Incident.create!(params)
    end
  end

  def self.parse_race input
    if input == 'Hispanic/Latino'
      'Hispanic'
    else
      input
    end
  end

  def self.parse_date(month, day, year)
    Date.parse("#{month} #{day}, #{year}")
  end

  def self.parse_unarmed input
    if input == 'No' || input == 'Non-lethal firearm'
      'Unarmed'
    elsif input == 'Unknown'
      'Unclear'
    else
      'Allegedly Armed'
    end
  end

  def self.scrape_lat_long_from_json
    file = File.read('db/seeds/mpv-data-out.json')
    json = JSON.parse(file)
    puts json.length
    json.each do | incident |
      lat = incident["lat"]
      long = incident["lng"]
      name = incident["name"]
      puts name

      incident = Incident.find_by(:victim_name => name)
      if incident
        incident.latitude = lat
        incident.longitude = long
        incident.save!
      end
    end
  end
end