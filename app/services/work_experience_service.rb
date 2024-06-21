class WorkExperienceService
  # Monta uma requisição que busca a experiência profissional à partir do usuário
  #
  # @param params [ActionController::Parameters] Parâmetros do controller
  # @return [Typhoeus::Request] Requisição que busca a experiência profissional à partir do usuário
  # Returns:
  def get_request(params)
    raise 'Method WorkExperience#get_request not implemented!'
  end

  # Mapeia a resposta da requisição para o DTO
  #
  # @param response [Typhoeus::Response] Response da requisição
  # @return [Array[WorkExperienceDTO]] Experiência profissional à partir do usuário
  # Returns:
  def to_dto(response)
    raise 'Method WorkExperience#to_dto not implemented!'
  end
end
