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
require 'browser/immediate'

module Lissio; class Adapter

class Storage < Adapter
	def initialize(value, options = {}, &block)
		super(value)

		@autoincrement = []

		if collection?
			@model  = options[:model] || value.model
			@filter = options[:filter] if options[:filter]
		end

		if block.arity == 0
			instance_exec(&block)
		else
			block.call(self)
		end if block
	end

	def model(name = nil)
		name ? @model = name : @model
	end

	def filter(&block)
		block ? @filter = block : @filter
	end

	def autoincrement(field = nil)
		if field
			@autoincrement << field
		else
			@autoincrement
		end
	end

	def autoincrement!(field, storage)
		storage[[:__autoincrement__, field]] ||= 0
		storage[[:__autoincrement__, field]] += 1
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

				def self.fetch(id)
					if value = storage[id]
						Promise.value(value)
					else
						Promise.error(:missing)
					end
				end

				def create
					key = id!

					if key && storage[key]
						Promise.error(:exists)
					else
						Promise.defer {
							adapter.autoincrement.each {|name|
								unless __send__ name
									__send__ "#{name}=", adapter.autoincrement!(name, storage)
								end
							}

							storage[id!] = self
						}
					end
				end

				def save
					if storage[id!]
						Promise.defer {
							storage[id!] = self
						}
					else
						Promise.error(:missing)
					end
				end

				def destroy(&block)
					if storage[id!]
						Promise.defer {
							storage.delete(id!)
						}
					else
						Promise.error(:missing)
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
					Promise.defer {
						new(storage.map {|name, value|
							next if Array === name && name.length == 2 && name.first == :__autoincrement__

							if !adapter.filter || adapter.filter.call(value, *args)
								value
							end
						}.compact)
					}
				end
			}
		end
	end

	def uninstall
		if model?
			@for.instance_eval {
				class << self
					remove_method :storage
					remove_method :fetch
				end

				remove_method :storage
				remove_method :create
				remove_method :save
				remove_method :destroy
			}
		else
			@for.instance_eval {
				class << self
					remove_method :storage
					remove_method :fetch
				end

				remove_method :storage
			}
		end
	end
end

end; end
