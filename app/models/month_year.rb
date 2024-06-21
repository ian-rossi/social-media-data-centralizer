# Representa o mês e o ano
class MonthYear
  attr_accessor :month, :year

  # @param month [Integer] Mês
  # @param year [Integer] Ano
  def initialize(month, year)
    @month = month
    @year = year
  end

  def to_s
    "#{@month}/#{@year}"
  end

  def to_str
    to_s
  end
end
