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

class View
	def self.element(name = nil)
		name ? @element = name : @element
	end

	def self.tag_name(name = nil)
		name ? @tag_name = name : @tag_name
	end

	def self.class_name(name = nil)
		name ? @class_name = name : @class_name
	end

	def self.events
		@events ||= Hash.new { |h| h[k] = [] }
	end

	def self.on(name, selector = nil, &block)
		events[name] << [selector, block]
	end

	def self.render(&block)
		define_method :render do |*args|
			instance_exec(*args, &block)
		end
	end

	def self.css(*args, &block)
		@style = CSS.create(*args, &block)
	end

	attr_accessor :parent

	def tag_name
		self.class.tag_name || :div
	end

	def class_name
		self.class.class_name || ""
	end

	def element
		return @element if @element

		scope = parent ? parent.element : $document
		elem  = if elem = self.class.element
			scope.at(elem)
		else
			Element.create tag_name
		end

		elem.add_class class_name unless class_name.empty?

		events.each {|name, blocks|
			blocks.each {|selector, block|
				elem.on(name, &block)
			}
		}

		@element = elem
	end

	def render(*); end

	def remove
		@element.remove if @element
	end

	def destroy
		return unless @element

		events.each {|name, blocks|
			blocks.each {|selector, block|
				@element.off(block)
			}
		}

		@element.remove
	end
end

end
