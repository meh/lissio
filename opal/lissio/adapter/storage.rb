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

		# FIXME: when it's fixed convert to += 1
		value = storage[[:__autoincrement__, field]]
		storage[[:__autoincrement__, field]] = value + 1
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
					proc {
						block.call(storage[id] || :error)
					}.defer
				end

				def create(&block)
					proc {
						key = id!

						if key && storage[key]
							block.call(:error) if block
						else
							adapter.autoincrement.each {|name|
								unless __send__ name
									__send__ "#{name}=", adapter.autoincrement!(name, storage)
								end
							}

							storage[id!] = self

							block.call(:ok) if block
						end
					}.defer
				end

				def save(&block)
					proc {
						if storage[id!]
							storage[id!] = self

							block.call(:ok) if block
						else
							block.call(:error) if block
						end
					}.defer
				end

				def destroy(&block)
					proc {
						if storage[id!]
							storage.delete(id!)

							block.call(:ok) if block
						else
							block.call(:error) if block
						end
					}.defer
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
					proc {
						block.call new(storage.map {|name, value|
							next if Array === name && name.length == 2 && name.first == :__autoincrement__

							if !adapter.filter || adapter.filter.call(value)
								value
							end
						}.compact)
					}.defer
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
