require 'opal-sprockets'
require 'uglifier'
require 'forwardable'

module Lissio

class Builder
	extend Forwardable

	attr_accessor :debug, :index, :main, :static, :source_maps, :sprockets
	def_delegators :@sprockets, :append_path, :use_gem

	def initialize(&block)
		@sprockets = Sprockets::Environment.new
		@main      = 'app'

		Opal.paths.each {|path|
			@sprockets.append_path path
		}

		block.call(self) if block
	end

	def build
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

	def lissio(source = main)
		"<script>#{Uglifier.compile(@sprockets[source].to_s + Opal::Sprockets.load_asset(source, @sprockets))}</script>"
	end
end

end
