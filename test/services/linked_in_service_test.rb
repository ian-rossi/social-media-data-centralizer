require_relative '../test_helper'
require_relative '../../app/services/work_experience_service'
require_relative '../../app/services/linkedin_service'
require_relative '../../app/models/month_year'
require_relative '../../app/models/rfc_9457_dto'
require_relative '../../app/models/work_experience_dto'
require 'active_support/all'
require 'action_controller/metal/strong_parameters'
require 'typhoeus'

describe LinkedInService do
  before :each do
    @service = LinkedInService.new
  end
  describe '#get_request' do
    context 'when linked_in_access_token exists' do
      it 'should return Typhoeus::Request' do
        params = ActionController::Parameters.new(linked_in_access_token: 'test')
        request = @service.get_request(params)
        expect(request.base_url).to eq(
          'https://api.linkedin.com/v2/me?projection=(positions:(companyName,endMonthYear,locationName,startMonthYear,title))'
        )
        original_options = request.original_options
        expect(original_options[:method]).to eq(:get)
        expect(original_options[:headers][:Authorization]).to eq('Bearer test')
        expect(original_options[:headers][:"X-RestLi-Protocol-Version"]).to eq('2.0.0')
      end
    end
    context 'when linked_in_access_token does not exists' do
      it 'should return nil' do
        params = ActionController::Parameters.new
        expect(@service.get_request(params)).to be_nil
      end
    end
  end
end
describe LinkedInService do
  before :each do
    @service = LinkedInService.new
  end
  describe '#to_dto' do
    context 'when Typhoeus::Response#failure? is true' do
      it 'should return RFC 9574 DTO' do
        body = { status: 403, serviceErrorCode: 402, message: 'Empty oauth2_access_token' }
        response = Typhoeus::Response.new(mock: true, response_code: 401, response_body: body.to_json)
        expected_response = RFC9457DTO.new(
          body['status'],
          body['message'],
          "Código de erro do LinkedIn: #{body['serviceErrorCode']}"
        )
        actual_response = @service.to_dto(response)
        linked_in_actual_response = actual_response[:linkedin]
        hash = linked_in_actual_response.instance_variables.each_with_object({}) do |var, test|
          test[var.to_s.delete('@')] = linked_in_actual_response.instance_variable_get(var)
        end
        expect(expected_response.status).to eq(hash[:status])
        expect(expected_response.title).to eq(hash[:title])
      end
    end
  end
end
describe LinkedInService do
  before :each do
    @service = LinkedInService.new
  end
  describe '#to_dto' do
    context 'when Typhoeus::Response#failure? is false' do
      it 'should return WorkExperienceDTO list' do
        body = { positions: [{ title: { localized: { pt_BR: 'Dev chorumex' },
                                        preferredLocale: { language: 'pt', country: 'BR' } },
                               startMonthYear: { day: 30, month: 2, year: 1712 } }] }
        response = Typhoeus::Response.new(mock: true, response_code: 200, response_body: body.to_json)
        expected_response = WorkExperienceDTO.new(nil, 'Dev chorumex', nil, MonthYear.new(2, 1712), nil)
        actual_response = @service.to_dto(response)
        linked_in_positions = actual_response[:linkedin]
        expect(linked_in_positions.length).to eq(1)
        linked_in_position = linked_in_positions[0]
        expect(linked_in_position.company_name).to be_nil
        expect(expected_response.job_position_name).to eq(linked_in_position.job_position_name)
        expect(linked_in_position.location_name).to be_nil
        expect(linked_in_position.start_month_year.month).to eq(2)
        expect(linked_in_position.start_month_year.year).to eq(1712)
        expect(linked_in_position.end_month_year).to be_nil
      end
    end
  end
end
