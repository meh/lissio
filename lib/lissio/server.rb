require 'opal/sprockets/server'

module Lissio

Opal::Server.send :attr_accessor, :static

class Server
  def initialize(*args, &block)
    server = Opal::Server.new(*args, &block)
    index = Index.new(nil, server)

    @app = Rack::Cascade.new([server, index])
  end

  def call(env)
    @app.call(env)
  end


  class Index < Opal::Server::Index
    # The original implementation limited the response to "/" and "/index.html"
    def call(env)
      [200, { 'Content-Type' => 'text/html' }, [html]]
    end
  end
end

end
