# Representa o contrato de uma experiência de trabalho
class WorkExperienceDTO
  attr_accessor :company_name, :job_position_name, :location_name, :start_month_year, :end_month_year

  # @param company_name [String] Nome da empresa
  # @param job_position_name [String] Nome do cargo
  # @param location_name [String] Nome da localização
  # @param start_month_year [MonthYear] Mês e ano de início
  # @param end_month_year [MonthYear] Mês e ano final
  def initialize(company_name, job_position_name, location_name, start_month_year, end_month_year)
    @company_name = company_name
    @job_position_name = job_position_name
    @location_name = location_name
    @start_month_year = start_month_year
    @end_month_year = end_month_year
  end
end
