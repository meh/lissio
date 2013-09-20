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
require 'forwardable'

module Lissio

class Application < Component
	include Singleton
	extend Forwardable

	def self.method_missing(id, *args, &block)
		instance.__send__ id, *args, &block
	end

	attr_reader :router
	def_delegators :@router, :route

	def initialize
		self.class.element 'body'

		@router = Router.new
	end

	def start
		render
		@router.update
	end
end

end
