require 'etc'

class WorkExperienceController < ApplicationController
  def initialize(work_experience_services = [LinkedInService.new, HackerRankService.new])
    super
    @work_experience_services = work_experience_services
  end

  def index
    number_of_processors = Etc.nprocessors
    hydra = Typhoeus::Hydra.new(max_concurrency: number_of_processors - 1)
    filtered_request_by_service = request_by_service(params)
    filtered_request_by_service.each_key { |req| hydra.queue(req) }
    hydra.run!
    filtered_request_by_service.reduce({}) { |acc, (req, service)| acc.merge(service.to_dto(req.response)) }
  end

  def request_by_service(params)
    request_by_service = @work_experience_services.group_by { |service| service.get_request(params) }
    request_by_service.filter { |req, _| !req.nil? }
  end
end
