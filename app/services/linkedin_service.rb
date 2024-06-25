require 'json'
# Classe de serviço responsável por mapear as chamadas de API do LinkedIn
class LinkedInService
  extend WorkExperienceService

  def get_request(params)
    linked_in_access_token = params[:linked_in_access_token]
    return new_request(linked_in_access_token) if linked_in_access_token.present?

    nil
  end

  def to_dto(response)
    body_str = response.body
    parsed_body = JSON.parse(body_str)
    return { linkedin: new_rfc_9457_dto(parsed_body) } if response.failure?

    { linkedin: parsed_body['positions'].map { |position| new_work_experience_dto(position) } }
  end

  private

  def new_rfc_9457_dto(error_body)
    RFC9457DTO.new(
      error_body['status'],
      error_body['message'],
      "Código de erro do LinkedIn: #{error_body['serviceErrorCode']}"
    )
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
      to_string(position['companyName']),
      to_string(position['title']),
      to_string(position['locationName']),
      to_month_year(position['startMonthYear']),
      to_month_year(position['endMonthYear'])
    )
  end

  # Converte um objeto do tipo MultiLocaleString para texto.
  # @see https://learn.microsoft.com/en-us/linkedin/k2/itm-preview/references/entities/multilocalestring
  def to_string(multi_locale_string)
    return nil if multi_locale_string.nil?

    preferred_locale = multi_locale_string['preferredLocale']
    language_tag = "#{preferred_locale['language']}_#{preferred_locale['country']}"
    multi_locale_string['localized'][language_tag]
  end

  # Converte um objeto do tipo Date para MonthYear.
  # @see https://learn.microsoft.com/en-us/linkedin/k2/itm-preview/references/entities/date
  def to_month_year(date_object)
    return nil if date_object.nil?

    MonthYear.new(date_object['month'], date_object['year'])
  end
end
