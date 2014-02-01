require 'rack/file'
require 'rack/urlmap'
require 'rack/builder'
require 'rack/directory'
require 'rack/showexceptions'

require 'opal/source_map'
require 'opal/sprockets/environment'

require 'forwardable'

module Lissio

class Server
	class SourceMap
		attr_accessor :prefix

		def initialize(sprockets)
			@sprockets = sprockets
			@prefix    = '/__opal_source_maps__'
		end

		def call(env)
			if asset = @sprockets[env['PATH_INFO'].gsub(/^\/|\.js\.map$/, '')]
				[200, { "Content-Type" => "text/json" }, [$OPAL_SOURCE_MAPS[asset.pathname].to_s]]
			else
				[404, {}, []]
			end
		end
	end

	class Prerender
		def initialize(app, server)
			@app    = app
			@server = server
		end

		def call(env)
			@app.call(env)
		end
	end

	class Index
		def initialize(server)
			@server = server
			@path   = server.index
		end

		def call(env)
			if env['PATH_INFO'] =~ /\.[^.]+$/
				[404, {"Content-Type" => "text/plain"}, []]
			else
				[200, { 'Content-Type' => 'text/html' }, [html]]
			end
		end

		def html
			source = if @path
				unless File.exist?(@path)
					raise "index does not exist: #{@path}"
				end

				File.read @path
			elsif File.exist? 'index.html.erb'
				File.read 'index.html.erb'
			else
				<<-HTML
					<!DOCTYPE html>
					<html>
					<head>
						<%= lissio %>
					</head>
					<body>
					</body>
					</html>
				HTML
			end

			::ERB.new(source).result binding
		end

		def lissio(source = @server.main)
			if @server.debug
				if (assets = @server.sprockets[source].to_a).empty?
					raise "Cannot find asset: #{source}"
				end

				assets.map {|a|
					%Q{<script src="/assets/#{a.logical_path}?body=1"></script>}
				}.join ?\n
			else
				"<script src=\"/assets/#{source}.js\"></script>"
			end
		end
	end

	extend Forwardable

	attr_accessor :debug, :index, :main, :static, :source_maps, :sprockets
	def_delegators :@sprockets, :append_path, :use_gem

	def initialize(&block)
		@sprockets = Opal::Environment.new
		@main      = 'app'

		block.call(self) if block
	end

	def path=(values)
		values.each { |path|
			append_path path
		}
	end

	def append_static(path)
		(@static ||= []) << path
	end

	def source_maps?
		@source_maps
	end

	def extend(&block)
		@extend = block
	end

	def app
		this  = self
		block = @extend

		@app ||= Rack::Builder.app do
			use Rack::ShowExceptions
			use Rack::Deflater

			map '/assets' do
				run this.sprockets
			end

			if this.source_maps?
				map this.source_maps.prefix do
					run this.source_maps
				end
			end

			use Prerender, this
			use Rack::Static, urls: this.static if this.static

			instance_exec(&block) if block

			run Index.new(this)
		end
	end

	def call(env)
		app.call(env)
	end
end

end
