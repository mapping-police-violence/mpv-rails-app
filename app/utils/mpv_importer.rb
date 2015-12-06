require 'csv'

class MpvImporter < DataImporter
  def self.preprocess_contents contents
    # sort consecutively by unique_mpv, with entries with missing values at the end.
    # this ensures that no new unique_mpv values will be assigned until the existing ones
    # have been imported, avoiding conflicts.
    contents.sort_by! do |a|
      missing = a.nil? || a[28].nil?
      [missing ? 1 : 0, a[28]]
    end
  end

  def self.is_valid(row)
    !row[0].nil? && !(/Victim name/ =~ row[0])
  end

  def self.import_row(row)
    existing_incidents = Incident.where(:unique_mpv => row[28])
    if existing_incidents.empty?
      Incident.create!(incident_hash(row))
    else
      existing_incidents.first.update_attributes!(incident_hash(row))
    end
  end

  def self.incident_hash(row)
    {
        :victim_name => row[0],
        :victim_age => row[1],
        :victim_gender => row[2],
        :victim_race => row[3],
        :victim_image_url => row[4],
        :incident_date => row[5],
        :incident_street_address => row[6],
        :incident_city => row[7],
        :incident_state => row[8],
        :incident_zip => row[9],
        :incident_county => row[10],
        :agency_responsible => row[11],
        :cause_of_death => row[12],
        :alleged_victim_crime => row[13],
        :crime_category => row[14],
        :aggregate_crime_category => row[15],
        :caveat => row[16],
        :solution => row[17],
        :incident_description => row[18],
        :official_disposition_of_death => row[19],
        :criminal_charges => row[20],
        :news_url => row[21],
        :mental_illness => row[22],
        :unarmed => row[23],
        :line_of_duty => row[24],
        :note => row[25],
        :in_custody => row[26],
        :arrest_related_death => row[27],
        :unique_mpv => row[28],
        :latitude => row[29],
        :longitude => row[30]
    }
  end
end