#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'json'
require 'forwardable'

module Lissio

class Model
	class Property
		attr_reader :name, :as

		def initialize(name, options)
			@name    = name
			@default = options[:default]
			@primary = options[:primary] || false
			@as      = options[:as]
		end

		def primary?
			@primary
		end

		def default
			if Proc === @default && @default.lambda?
				@default.call
			else
				@default
			end
		end

		def new(data)
			return default if data.nil?
			return data if !@as || @as === data

			if @as.ancestors.include?(Model)
				if @as.primary && @as.primary.as === data
					return data
				else
					return @as.new(*data)
				end
			end

			case
			when @as == Boolean then !!data
			when @as == Array   then Array(data)
			when @as == String  then data.to_s
			when @as == Symbol  then data.to_sym
			when @as == Integer then data.to_i
			when @as == Float   then data.to_f
			when @as == Time    then Time.parse(data)
			when Proc === @as   then @as.call(data)
			else                     @as.new(*data)
			end
		end

		def define(klass)
			name = @name
			as   = @as

			if Class === @as && @as.ancestors.include?(Model)
				klass.define_method name do
					if id = instance_variable_get("@#{name}")
						as.fetch(id)
					end
				end

				klass.define_method "#{name}!" do
					instance_variable_get("@#{name}")
				end

				klass.define_method "#{name}=" do |value|
					if as === value
						value = value.id!
					end

					if instance_variable_get("@#{name}") != value
						@changed << name

						instance_variable_set "@#{name}", value
					end
				end
			else
				klass.define_method name do
					instance_variable_get "@#{name}"
				end

				klass.define_method "#{name}=" do |value|
					if instance_variable_get("@#{name}") != value
						@changed << name

						instance_variable_set "@#{name}", value
					end
				end
			end
		end
	end

	def self.inherited(klass)
		klass.instance_eval {
			@properties = {}
		}

		return if self == Model

		klass.instance_eval {
			def self.properties
				superclass.properties.merge @properties
			end
		}
	end

	def self.adapter(klass = nil, *args, &block)
		if klass
			@adapter.uninstall if @adapter

			@adapter = klass.new(self, *args, &block)
			@adapter.install
		else
			@adapter
		end
	end

	def self.for(klass, *args, &block)
		Class.new(self) {
			adapter(klass, *args, &block)
		}
	end

	def self.properties
		@properties
	end

	def self.property(name, options = {})
		# @properties is accessed directly to allow proper inheritance
		@properties[name] = Property.new(name, options).tap {|property|
			property.define(self)

			if property.primary?
				@primary = property
			end
		}
	end

	def self.primary
		@primary
	end

	extend Forwardable
	def_delegators :class, :adapter, :properties

	attr_reader :fetched_with, :changed

	def initialize(data = nil, *fetched_with)
		@fetched_with = fetched_with
		@changed      = []

		if data
			properties.each {|name, property|
				instance_variable_set "@#{name}", property.new(data[name])
			}
		end
	end

	def changed?
		not @changed.empty?
	end

	def id!
		name, = properties.find {|_, property|
			property.primary?
		}

		instance_variable_get "@#{name || :id}"
	end

	def to_h
		Hash[properties.map {|name, _|
			[name, instance_variable_get("@#{name}")]
		}]
	end

	def as_json
		hash = to_h
		hash[JSON.create_id] = self.class.name

		hash
	end

	def to_json
		as_json.to_json
	end

	def self.json_create(data)
		new(data)
	end

	def inspect
		"#<#{self.class.name}: #{properties.map {|name, _|
			"#{name}=#{instance_variable_get("@#{name}").inspect}"
		}.join(' ')}>"
	end
end

end
