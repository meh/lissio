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
		attr_reader :name

		def initialize(name, options)
			@name    = name
			@primary = options[:primary] || false
			@as      = options[:as]
		end

		def primary?
			@primary
		end

		def new(data)
			return data if !@as || @as === data

			case
			when @as == Array   then Array(data)
			when @as == String  then data.to_s
			when @as == Symbol  then data.to_sym
			when @as == Integer then data.to_i
			when @as == Float   then data.to_f
			when @as == Time    then Time.parse(data)
			else                     @as.new(*data)
			end
		end
	end

	def self.inherited(klass)
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
		(@properties ||= {})[name] = Property.new(name, options)

		define_method name do
			instance_variable_get "@#{name}"
		end

		define_method "#{name}=" do |value|
			if instance_variable_get("@#{name}") != value
				@changed << name

				instance_variable_set "@#{name}", value
			end
		end
	end

	extend Forwardable
	def_delegators :class, :adapter, :properties

	attr_reader :fetched_with, :changed

	def initialize(data = nil, *fetched_with)
		@fetched_with = fetched_with
		@changed      = []

		if data
			properties.each {|name, property|
				if datum = data[name]
					instance_variable_set "@#{name}", property.new(datum)
				end
			}
		end
	end

	def changed?
		not @changed.empty?
	end

	def id!
		# FIXME: Enumerable#detect
		name, = properties.find {|property|
			property.last.primary?
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
