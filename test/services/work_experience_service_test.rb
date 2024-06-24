require_relative '../../app/services/work_experience_service'

describe WorkExperienceService do
  before :each do
    @service = WorkExperienceService.new
  end
  describe '#get_request' do
    context 'when WorkExperienceService#get_request is invoked' do
      it "should raise 'WorkExperienceService#get_request not implemented!'" do
        expect { @service.get_request(nil) }.to raise_error(
          RuntimeError,
          'Method WorkExperienceService#get_request not implemented!'
        )
      end
    end
  end
  describe '#to_dto' do
    context 'when WorkExperienceService#to_dto is invoked' do
      it "should raise 'WorkExperienceService#to_dto not implemented!'" do
        expect { @service.to_dto(nil) }.to raise_error(
          RuntimeError,
          'Method WorkExperienceService#to_dto not implemented!'
        )
      end
    end
  end
end
