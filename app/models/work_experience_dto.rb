class WorkExperienceDTO
  EMPLOYMENT_TYPE = %i[FULL_TIME HALF_TIME AUTONOMOUS FREELANCE TEMPORARY INTERN APPRENTICE
                       TRAINEE THIRD_PARTY].freeze

  # Cria uma nova instância
  #
  # @param company_name [String] Nome da empresa
  # @param job_position_name [String] Nome do cargo
  # @param employment_type [Integer] Tipo de emprego
  # @param location [String] Localização
  def initialize(
    company_name: String,
    job_position_name: String,
    employment_type: Integer,
    location: String
  )
    @company_name = company_name
    @job_position_name = job_position_name
    @employment_type = EMPLOYMENT_TYPE[employment_type]
    @location = location
  end
end
