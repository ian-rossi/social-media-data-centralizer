class LinkedInService
  extend ::WorkExperienceService
  def get_request(params)
    linked_in_access_token = params.require(:linked_in_access_token)
    Typhoeus::Request.new(
      'https://api.linkedin.com/v2/me?projection=(position:(companyName,endMonthYear,locationName,startMonthYear,title))',
      { headers: { 'Authorization': "Bearer #{linked_in_access_token}" } }
    )
  end
end
