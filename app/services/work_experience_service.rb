class WorkExperienceService
  # Monta uma requisição que busca a experiência profissional à partir do usuário
  #
  # @param params [ActionController::Parameters] Parâmetros do controller
  # @return [Typhoeus::Request, void] Requisição que busca a experiência profissional à partir do usuário
  # Returns:
  def get_request(params)
    raise 'Method WorkExperienceService#get_request not implemented!'
  end

  # Mapeia a resposta da requisição para o DTO
  #
  # @param response [Typhoeus::Response] Response da requisição
  # @return [{[key: String] : Array[WorkExperienceDTO, RFC9457DTO]}] Experiência profissional à partir do usuário
  def to_dto(response)
    raise 'Method WorkExperienceService#to_dto not implemented!'
  end
end
