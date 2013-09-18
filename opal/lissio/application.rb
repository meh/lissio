#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'singleton'
require 'ostruct'

module Lissio

class Application < View
	element 'body'

	include Singleton

	def self.method_missing(id, *args, &block)
		instance.__send__ id, *args, &block
	end

	attr_reader :views, :router

	def initialize
		@views  = OpenStruct.new
		@router = Router.new
	end

	def start
		render
		@router.update
	end
end

end
