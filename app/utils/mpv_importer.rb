require 'csv'

class MpvImporter < DataImporter

  def self.is_header(row)
    if row[1].respond_to? :downcase
      first = row[0].downcase
      second = row[1].downcase

      # header text capitalization and punctuation varies slightly from version to version
      # (e.g. "Victim Name" vs "Victim's name")
      /victim/ =~ first && /victim/ =~ second && /name/ =~ first && /age/ =~ second
    else
      false
    end
  end

  def self.expected_column_count
    return 40
  end

  def self.import_rows(contents)
    # first pass: only import entries that already have unique_mpvs.
    # this ensures that no new unique_mpv values will be assigned until the existing ones
    # have been imported, avoiding conflicts.
    entries_missing_unique_mpv = []
    contents.each_with_index do |row, index|
      next if !is_valid(row, index)
      if row[37].nil?
        entries_missing_unique_mpv.append(row)
      else
        import_row(row)
      end
    end

    # second pass: import the remaining entries
    super entries_missing_unique_mpv
  end

  def self.import_row(row)
    existing_incidents = Incident.where(:unique_mpv => row[37])
    if existing_incidents.empty?
      Incident.create!(incident_hash(row))
    else
      new_data = incident_hash(row)
      # don't overwrite existing latitude/longitude, since we auto-geocode all new entries
      [:latitude, :longitude].each do |key|
        new_data.delete(key)
      end
      existing_incidents.first.update_attributes!(new_data)
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
        :needs_review => row[34],
        :sort_order => row[35],
        :unique_identifier => row[36],
        :unique_mpv => row[37],
        :latitude => row[38],
        :longitude => row[39]
    }
  end
end