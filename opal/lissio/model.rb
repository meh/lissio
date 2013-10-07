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
	def self.adapter(klass = nil, *args)
		klass ? @adapter = klass.new(self, *args) : @adapter
	end

	def self.primary_key(name = nil)
		name ? @primary_key = name : @primary_key
	end

	def self.attributes(*names)
		if names.empty?
			@attributes
		else
			@attributes = names.each {|name|
				attr_accessor name
			}
		end
	end

	def initialize(data)
		self.class.attributes.each {|name|
			instance_variable_set "@#{name}", data[name]
		}
	end

	def primary_key
		instance_variable_get "@#{self.class.primary_key}"
	end

	def to_json
		"{#{self.class.attributes.map {|name|
			"#{name.to_json}:#{instance_variable_get("@#{name}").to_json}"
		}.join(?,)}}"
	end

	def inspect
		"#<#{self.class.name}: #{self.class.attributes.map {|name|
			"#{name}=#{instance_variable_get("@#{name}").inspect}"
		}.join(' ')}>"
	end
end

end
