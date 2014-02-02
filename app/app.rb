require 'opal'
require 'lissio'

class Application < Lissio::Application
  def initialize
    super
  end

  html do
    div "Vai col lissio!"
  end

  css do
    font size: 42.px
    text align: :center
  end
end
