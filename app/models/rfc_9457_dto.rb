require 'uri'

# Representa o contrato da especificação RFC 9457.
# @see https://www.rfc-editor.org/rfc/rfc9457.html#section-3.1
class RFC9457DTO
  attr_accessor :type, :status, :title, :detail, :instance

  # @param type [URI] Tipo do problema
  # @param status [Integer] Código do status HTTP
  # @param title [String] Título resumido do problema
  # @param detail [String] Explicação detalhada sobre o problema
  # @param instance [URI] Referência que identifica a ocorrência específica do problema
  def initialize(status, title, detail = nil, instance = nil, type = URI('about:blank'))
    @type = type
    @status = status
    @title = title
    @detail = detail
    @instance = instance
  end
end
