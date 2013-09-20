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

class Component
	def self.element(name = nil)
		name ? @element = name : @element
	end

	def self.tag(options = nil)
		options ? @tag = options : @tag
	end

	def self.events
		@events ||= Hash.new { |h| h[k] = [] }
	end

	def self.on(name, selector = nil, method = nil, &block)
		if block
			events[name] << [selector, block]
		elsif method
			events[name] << [selector, method]
		else
			events[name] << [nil, method]
		end
	end

	def self.render(&block)
		define_method :render, &block
	end

	def self.html(string = nil, &block)
		if block
			render {
				element.clear
				DOM::Builder.new($document, element, &block)
			}
		else
			render {
				element.inner_html = string
			}
		end
	end

	def self.css(*args, &block)
		@style = CSS(*args, &block)
	end

	attr_accessor :parent

	def initialize(parent = nil)
		@parent = parent
	end

	def tag
		self.class.tag || { name: :div }
	end

	def element
		return @element if @element

		scope = parent ? parent.element : $document
		elem  = if elem = self.class.element
			scope.at(elem)
		else
			DOM::Element.create tag[:name] || :div
		end

		elem.add_class tag[:class] if tag[:class]
		elem[:id] = tag[:id] if tag[:id]

		self.class.events.each {|name, blocks|
			blocks.each {|selector, block|
				if block.is_a? Symbol
					elem.on(name, selector) {|*args|
						__send__ name, *args
					}
				else
					elem.on(name, selector, &block)
				end
			}
		}

		@element = elem
	end

	def render(*); end

	def remove
		@element.remove if @element
	end

	alias destroy remove
end

end
