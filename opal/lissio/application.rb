require 'singleton'
require 'forwardable'

module Lissio

class Application < Component
	def self.inherited(klass)
		super

		klass.include Singleton

		$document.ready do
			klass.start
		end
	end

	def self.expose(what, options = {})
		if what.start_with?(?@)
			name = what[1 .. -1]

			define_singleton_method name do
				instance.__send__ name
			end

			attr_reader name
		else
			define_singleton_method what do |*args, &block|
				instance.__send__ what, *args, &block
			end
		end
	end

	expose :start
	expose :refresh
	expose :navigate
	expose :@router

	extend Forwardable
	def_delegators :@router, :navigate, :route, :missing

	def initialize
		super()

		@router = Lissio::Router.new(fragment: false)
	end

	def start
		render
		router.update
	end

	def refresh
		router.update
	end

	element :body

	on :click, 'a[href^="/"], a[href="back"], a[href="forward"]' do |e|
		unless e.alt? || e.ctrl? || e.meta? || e.shift?
			e.prevent
			navigate e.target[:href] || e.target.ancestors('a').first[:href]
		end
	end
end

end
