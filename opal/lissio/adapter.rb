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
	attr_reader :model

	def initialize(model)
		@model = model
	end

	def install
		raise NotImplementedError, "install has not been implemented"
	end

	def uninstall
		raise NotImplementedError, "uninstall has not been implemented"
	end
end

end
