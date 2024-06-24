# Classe de serviço responsável por mapear as chamadas de API do LinkedIn
class LinkedInService
  extend WorkExperienceService

  def get_request(params)
    permitted_params = params.permit(:linked_in_access_token)
    LinkedInService.new_request(permitted_params[:linked_in_access_token]) if permitted_params.permitted?
    nil
  end

  def to_dto(response)
    body = response.body
    if response.failure?
      { linkedin: RFC9457DTO.new(body.status, body.message, "Código de erro do LinkedIn: #{body.serviceErrorCode}") }
    end
    { linkedin: body.positions.map { |position| LinkedInService.new_work_experience_dto(position) } }
  end

  def new_request(linked_in_access_token)
    Typhoeus::Request.new(
      'https://api.linkedin.com/v2/me?projection=(positions:(companyName,endMonthYear,locationName,startMonthYear,title))',
      method: :get,
      headers: {
        'Authorization': "Bearer #{linked_in_access_token}",
        'X-RestLi-Protocol-Version': '2.0.0'
      }
    )
  end

  def new_work_experience_dto(position)
    WorkExperienceDTO.new(
      LinkedInService.to_string(position.companyName),
      LinkedInService.to_string(position.title),
      LinkedInService.to_string(position.locationName),
      LinkedInService.to_month_year(position.startMonthYear),
      LinkedInService.to_month_year(position.endMonthYear)
    )
  end

  # Converte um objeto do tipo MultiLocaleString para texto.
  # @see https://learn.microsoft.com/en-us/linkedin/k2/itm-preview/references/entities/multilocalestring
  def to_string(multi_locale_string)
    nil if multi_locale_string.nil?
    preferred_locale = multi_locale_string.preferredLocale
    language_tag = "#{preferred_locale.language}_#{preferred_locale.country}"
    multi_locale_string.localized[language_tag]
  end

  # Converte um objeto do tipo Date para MonthYear.
  # @see https://learn.microsoft.com/en-us/linkedin/k2/itm-preview/references/entities/date
  def to_month_year(date_object)
    nil if date_object.nil?
    MonthYear.new(date_object.month, date_object.year)
  end

  private_class_method :new_request, :new_work_experience_dto, :to_string, :to_month_year
end
