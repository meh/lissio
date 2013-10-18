require 'singleton'
require 'forwardable'

module Lissio

class Application < Component
	include Singleton

	extend SingleForwardable
	extend Forwardable

	def_single_delegators :instance, :start, :navigate
	def_instance_delegators :@router, :navigate

	def initialize
		@router = Lissio::Router.new(fragment: false)
	end

	def start
		render

		@router.update
	end

	element :body
end

end
