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
		Uglifier.compile(@sprockets[@main].to_s + Opal::Sprockets.load_asset(@main, @sprockets))
	end
end

end
