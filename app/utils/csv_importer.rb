require 'csv'

class CsvImporter
  def self.import filename
    CSV.foreach filename do |row|
      next if row[0].nil? || row[0] == "Id"

      Incident.create!({
                          :victim_name => row[1],
                          :victim_age => row[2],
                          :victim_gender => row[3],
                          :victim_race => row[4],
                          :victim_image_url => row[5],
                          :incident_date => row[6],
                          :incident_street_address => row[7],
                          :incident_city => row[8],
                          :incident_state => row[9],
                          :incident_zip => row[10],
                          :incident_county => row[11],
                          :agency_responsible => row[12],
                          :cause_of_death => row[13],
                          :alleged_victim_crime => row[14],
                          :crime_category => row[15],
                          :aggregate_crime_category => row[16],
                          :caveat => row[17],
                          :solution => row[18],
                          :incident_description => row[19],
                          :official_disposition_of_death => row[20],
                          :criminal_charges => row[21],
                          :news_url => row[22],
                          :mental_illness => row[23],
                          :unarmed => row[24],
                          :line_of_duty => row[25],
                          :note => row[26],
                          :in_custody => row[27],
                          :arrest_related_death => row[28],
                          :unique_mpv => row[29],
                          :latitude => row[32],
                          :longitude => row[33]
                      })

    end
  end
end