#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'browser/storage'

module Lissio; class Adapter

class Storage < Adapter
	def initialize(value, options = {})
		super(value)

		if collection?
			@model = options[:model] || value.model
		end
	end

	def install
		if model?
			@for.instance_eval {
				def self.storage
					$window.storage(name)
				end

				def storage
					self.class.storage
				end

				def self.fetch(id, &block)
					block.call(storage[id] || :error)
				end

				def create(&block)
					if storage[id!]
						block.call(:error) if block
					else
						storage[id!] = self

						block.call(:ok) if block
					end
				end

				def save(&block)
					if storage[id!]
						storage[id!] = self

						block.call(:ok) if block
					else
						block.call(:error) if block
					end
				end

				def destroy(&block)
					if storage[id!]
						storage.delete(id!)

						block.call(:ok) if block
					else
						block.call(:error) if block
					end
				end
			}
		else

		end
	end

	def uninstall
	end
end

end; end
