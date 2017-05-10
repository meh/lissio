#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'browser/history'

module Lissio

class Router
	attr_reader :routes, :options, :history

	def initialize(options = {}, &block)
		@routes   = []
		@missing  = proc { }
		@options  = options
		@location = $document.location
		@initial  = @location.uri
		@history  = $window.history

		@change = if fragment?
			$window.on 'hash:change' do
				update
			end
		else
			$window.on 'pop:state' do |e|
				if @initial == @location.uri
					@initial = nil
					break
				else
					@initial = nil
				end

				update
			end
		end

		if block.arity == 0
			instance_exec(&block)
		else
			block.call(self)
		end if block
	end

	def fragment?
		@options[:fragment] != false || !`window.history.pushState`
	end

	def html5!
		return unless fragment?

		@options[:fragment] = false

		@change.off
		@change = $window.on 'pop:state' do
			update
		end
	end

	def fragment!
		return if fragment?

		@options[:fragment] = true

		@change.off
		@change = $window.on 'hash:change' do
			update
		end
	end

	def path
		if fragment?
			if @location.fragment.empty?
				"/"
			else
				@location.fragment.sub(/^#*/, '')
			end
		else
			@location.path
		end
	end

	def route(path, &block)
		Route.new(path, &block).tap {|route|
			@routes << route
		}
	end
	
	def missing(&block)
		@missing = block
	end

	def update
		match path
	end

	def navigate(path)
		@initial = nil

		if path == :back
			return @history.back
		end

		if path == :forward
			return @history.forward
		end

		if path == self.path
			return update
		end

		if fragment?
			@location.fragment = "##{path}"
		else
			@history.push(path)
			update
		end
	end

private
	def match(path)
		@missing.call unless @routes.find {|route|
			route.match path
		}
	end

	class Route
		# Regexp for matching named params in path
		NAME = /:(\w+)/

		# Regexp for matching named splats in path
		SPLAT = /\\\*(\w+)/

		attr_reader :names

		def initialize(pattern, &block)
			@names = []
			@block = block

			pattern = Regexp.escape(pattern)

			pattern.scan(NAME) {|m|
				@names << m[0]
			}

			pattern.scan(SPLAT) {|m|
				@names << m[0]
			}

			pattern = pattern.gsub(NAME, "([^\\/]+)").
			                  gsub(SPLAT, "(.+?)")

			@regexp = Regexp.new "^#{pattern}$"
		end

		def match(path)
			if match = @regexp.match(path)
				params = {}

				@names.each_with_index {|name, index|
					params[name] = match[index + 1].decode_uri_component
				}

				@block.call params if @block

				true
			else
				false
			end
		end
	end
end

end
