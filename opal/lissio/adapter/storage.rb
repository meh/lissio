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
	attr_reader :model, :block

	def initialize(value, options = {}, &block)
		super(value)

		if collection?
			@model = options[:model] || value.model
		end

		@block = block
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
			@for.instance_eval {
				def self.storage
					$window.storage(adapter.model.name)
				end

				def storage
					self.class.storage
				end

				def self.fetch(*args, &block)
					block.call new(storage.map {|name, value|
						if !adapter.block || adapter.block.call(value)
							value
						end
					}.compact)
				end
			}
		end
	end

	def uninstall
	end
end

end; end
