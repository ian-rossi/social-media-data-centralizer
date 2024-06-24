# Classe de serviço responsável por mapear as chamadas de API do HackerRank
class HackerRankService
  extend WorkExperienceService

  def get_request(params)
    permitted_params = params.permit(:hacker_rank_user_name)
    HackerRankService.new_request(permitted_params[:hacker_rank_user_name]) if permitted_params.permitted?
    nil
  end

  def to_dto(response)
    body = response.body
    { hacker_rank: body.errors.map { |error| HackerRankService.to_rfc_9457_dto(error) } } if response.failure?
    { hacker_rank: body.data.map { |hacker_company| HackerRankService.new_work_experience_dto(hacker_company) } }
  end

  def new_request(hacker_rank_user_name)
    Typhoeus::Request.new(
      "https://www.hackerrank.com/community/v1/hackers/#{hacker_rank_user_name}/hacker_companies",
      method: :get
    )
  end

  def to_rfc_9457_dto(error_object)
    RFC9457DTO.new(
      Integer(error_object.status),
      error_object.title,
      error_object.detail
    )
  end

  def new_work_experience_dto(hacker_company)
    attributes = hacker_company.attributes
    WorkExperienceDTO.new(
      attributes.company_profile.name,
      attributes.job_title,
      attributes.location,
      HackerRankService.to_month_year(attributes.start_month, attributes.start_year),
      HackerRankService.to_month_year(attributes.end_month, attributes.end_year)
    )
  end

  def to_month_year(month, year)
    nil if month.nil? || year.nil?
    MonthYear.new(month, year)
  end

  private_class_method :new_request, :to_rfc_9457_dto, :new_work_experience_dto, :to_month_year
end
