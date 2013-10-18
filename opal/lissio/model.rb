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
			case @as
			when nil     then data
			when Array   then Array(data)
			when String  then data.to_s
			when Integer then data.to_i
			when Float   then data.to_f
			when Time    then Time.parse(data)
			else              @as.new(*data)
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

		attr_accessor name
	end

	def initialize(data = nil)
		if data
			self.class.properties.each {|name, property|
				instance_variable_set "@#{name}", property.new(data[name])
			}
		end
	end

	def adapter
		self.class.adapter
	end

	def id!
		name, _ = self.properties.find {|_, property|
			property.primary?
		}

		if name
			self.id
		else
			instance_variable_get "@#{name}"
		end
	end

	def to_json
		"{#{self.class.properties.map {|name, _|
			"#{name.to_json}:#{instance_variable_get("@#{name}").to_json}"
		}.join(?,)}}"
	end

	def inspect
		"#<#{self.class.name}: #{self.class.properties.map {|name, _|
			"#{name}=#{instance_variable_get("@#{name}").inspect}"
		}.join(' ')}>"
	end
end

end
