require 'csv'

class CountedImporter
  def self.import file
    csv_contents = file.read
    CSV.parse(csv_contents) do |row|
      next if row[0].nil? || row[0] == "name"

      Incident.create!({
                           :victim_name => row[0],
                           :victim_age => row[1],
                           :victim_gender => row[2],
                           :victim_race => parse_race(row[3]),
                           :incident_date => parse_date(row[4],row[5],row[6]),
                           :incident_street_address => row[7],
                           :incident_city => row[8],
                           :incident_state => row[9],
                           :cause_of_death => row[10],
                           :agency_responsible => row[11],
                           :unarmed => parse_unarmed(row[12])
                       })
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