class Incident < ActiveRecord::Base

  before_create :generate_unique_mpv

  @@last_geocode_time = nil
  MAX_GEOCODE_CALLS_PER_SECOND = 10  # google API limit
  geocoded_by :full_street_address
  after_validation :geocode_with_rate_limit,
                   if: ->(obj) {
                     (obj.latitude.nil? ||  obj.longitude.nil? ) &&
                     (obj.incident_street_address_changed? ||
                         obj.incident_city_changed? ||
                         obj.incident_state_changed? ||
                         obj.incident_zip_changed?)
                   }

  def geocode_with_rate_limit
    if !@@last_geocode_time.nil?
      sleep_duration = @@last_geocode_time + 1.0/MAX_GEOCODE_CALLS_PER_SECOND - Time::now
      sleep(sleep_duration) unless sleep_duration < 0
    end
    geocode
    @@last_geocode_time = Time::now
  end

  def full_street_address
    [incident_street_address,
     incident_city,
     incident_state,
     incident_zip].reject(&:nil?).join(', ')
  end

  def self.state_options
    [
        'AK', 'AL', 'AR', 'AZ', 'CA', 'CO', 'CT', 'DC', 'DE', 'FL', 'GA', 'HI', 'IA', 'ID', 'IL', 'IN', 'KS', 'KY',
        'LA', 'MA', 'MD', 'ME', 'MI', 'MN', 'MO', 'MS', 'MT', 'NC', 'ND', 'NE', 'NH', 'NJ', 'NM', 'NV', 'NY', 'OH',
        'OK', 'OR', 'PA', 'RI', 'SC', 'SD', 'TN', 'TX', 'UT', 'VA', 'VT', 'WA', 'WI', 'WV', 'WY'
    ]
  end

  def self.crime_category_options
    ['Violent Crime (Non Lethal); Armed with Gun',
     'Violent Crime (Non Lethal); No Gun',
     'Violent Crime (Potentially Lethal); Armed with Gun',
     'Violent Crime (Potentially Lethal); No Gun',
     'No Crime',
     'Property Crime; Armed with Gun',
     'Property Crime; No Gun',
     'Traffic Violation; Armed with Gun',
     'Traffic Violation; No Gun',
     'Murder; Armed with Gun',
     'Murder; No Gun',
     'Other',
     'Unknown/Unspecified',
     'Drugs',
     'Broken Windows Offense',
     'Weapons Possession Offense']
  end

  def self.aggregate_crime_category_options
    ['Criminal Suspect with Gun',
     'Criminal Suspect with No Gun',
     'Traffic Violation with No Gun',
     'Broken Windows Offense',
     'No Crime',
     'Other',
     'Unknown/Unspecified']
  end

  def self.gender_options
    ['Male', 'Female', 'Other']
  end

  def self.race_options
    ['Black', 'White', 'Hispanic', 'Asian', 'Pacific Islander', 'Native American', 'Unknown Race']
  end

  def self.cause_of_death_options
    ['Asphyxiation', 'Beaten', 'Gunshot', 'Taser', 'Beanbag',
     'Vehicle', 'Death in Custody', 'Medical Emergency',
     'Physical restraint', 'Pepper Spray', 'Other']
  end

  def self.official_disposition_of_death_options
    ['Unreported',
     'Unknown',
     'Justified',
     'Charged',
     'Pending Investigation',
     'Other']
  end

  def self.mental_illness_options
    ['Yes', 'No', 'Unknown', 'Drug or Alcohol use']
  end

  def self.unarmed_options
    ['Unarmed',
     'Allegedly Armed',
     'Unclear',
     'Vehicle']
  end

  def self.line_of_duty_options
    ['Line of Duty',
     'Not line of duty/Accidental']
  end

  def self.in_custody_options
    ['In-custody',
     'Inmate',
     'No']
  end

  def self.criminal_charges_options
    ['No Known Charges',
     'Charged with Crime']
  end

  private
  def generate_unique_mpv
    if self.unique_mpv.nil?
      self.unique_mpv = UniqueMpvSeq.next
    elsif self.unique_mpv > UniqueMpvSeq.last
      # If the existing unique_mpv is higher than anything we've seen before, advance the sequence
      # counter to match it. This will work as long as all entries with existing unique_mpv
      # values are imported prior to assigning any new unique_mpv values. For the time being, this
      # assumption is enforced in the importer. If it is violated, collisions may result.
      UniqueMpvSeq.update_last(self.unique_mpv)
    end
  end

end