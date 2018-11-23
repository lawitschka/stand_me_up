class PublicHoliday
  include Singleton

  attr_reader :holidays

  def initialize
    @holidays = YAML.load_file(Rails.root.join('config', 'public_holidays.yml'))
  end

  def is_public_holiday?(day = Date.today)
    holidays.any? { |holiday| holiday == day }
  end
end
