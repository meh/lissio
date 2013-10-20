#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

module Lissio

class Adapter
	attr_reader :for

	def initialize(value)
		if value.ancestors.include?(Model)
			@collection = false
			@model      = true
		elsif value.ancestors.include?(Collection)
			@collection = true
			@model      = false
		else
			raise ArgumentError, "the passed value isn't a Model or a Collection"
		end

		@for = value
	end

	def model?
		@model
	end

	def collection?
		@collection
	end

	def install
		raise NotImplementedError, "install has not been implemented"
	end

	def uninstall
		raise NotImplementedError, "uninstall has not been implemented"
	end
end

end
