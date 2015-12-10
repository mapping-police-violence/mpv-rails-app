require 'csv'

class MpvImporter < DataImporter
  def self.preprocess_contents contents
    # sort consecutively by unique_mpv, with entries with missing values at the end.
    # this ensures that no new unique_mpv values will be assigned until the existing ones
    # have been imported, avoiding conflicts.
    contents.sort_by! do |a|
      missing = a.nil? || a[36].nil?
      [missing ? 1 : 0, a[36]]
    end
  end

  def self.is_header(row)
    /Victim name/ =~ row[0]
  end

  def self.expected_column_count
    return 39
  end

  def self.import_row(row)
    existing_incidents = Incident.where(:unique_mpv => row[36])
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
        :within_city_limits => row[8],
        :incident_state => row[9],
        :incident_zip => row[10],
        :incident_county => row[11],
        :agency_responsible => row[12],
        :officers_involved => row[13],
        :race_of_officers_involved => row[14],
        :gender_of_officers_involved => row[15],
        :notes_related_to_officers_involved => row[16],
        :cause_of_death => row[17],
        :alleged_victim_crime => row[18],
        :crime_category => row[19],
        :aggregate_crime_category => row[20],
        :suspect_weapon_type => row[21],
        :caveat => row[22],
        :solution => row[23],
        :incident_description => row[24],
        :official_disposition_of_death => row[25],
        :criminal_charges => row[26],
        :news_url => row[27],
        :mental_illness => row[28],
        :unarmed => row[29],
        :line_of_duty => row[30],
        :note => row[31],
        :in_custody => row[32],
        :arrest_related_death => row[33],
        :sort_order => row[34],
        :unique_identifier => row[35],
        :unique_mpv => row[36],
        :latitude => row[37],
        :longitude => row[38]
    }
  end
end