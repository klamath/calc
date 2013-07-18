class SearchQuery
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :date

  validates_presence_of :date
  validates_format_of :date, :with => /^[0-9]{4}\/[0-9]{2}\/[0-9]{2}\s*-\s*[0-9]{4}\/[0-9]{2}\/[0-9]{2}$/

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def date_start
    Time.parse(date.split('-')[0]).to_date
  end

  def date_end
    Time.parse(date.split('-')[1]).to_date
  end

  def persisted?
    false
  end

end

