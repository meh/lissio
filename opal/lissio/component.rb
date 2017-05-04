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
	def self.inherited(klass)
		return if self == Component

		element = @element
		tag     = @tag
		events  = @events

		klass.instance_eval {
			@element = element

			if tag
				@tag = tag.dup
				@tag[:class] = @tag[:class].dup
			end

			if events
				@events = events.dup
				@events.each_key {|key|
					@events[key] = @events[key].dup
				}
			end
		}
	end

	def self.element(name = nil)
		name ? @element = name : @element
	end

	def self.tag(options = nil)
		return @tag unless options

		@tag ||= {}

		if cls = options.delete(:class)
			@tag[:class] = Array(@tag[:class]).concat(Array(cls))
		end

		@tag.merge!(options)
	end

	def self.tag!(options = nil)
		options ? @tag = options : @tag
	end

	def self.inheritance
		ancestors.take_while {|klass|
			klass != Component
		}.map {|klass|
			next unless klass.ancestors.include?(Component)
			next unless klass.css

			tag     = klass.tag
			element = klass.element
			parent  = klass.superclass

			if parent != Component
				next if element != parent.element
				next if tag && !parent.tag
				next if tag && (tag[:class] != parent.tag[:class] || tag[:id] != parent.tag[:id])
			else
				next if element
				next if tag && (tag[:class] || tag[:id])
			end

			if klass.name
				klass.name.gsub(/::/, '-').downcase
			else
				"lissio-#{klass.object_id}"
			end
		}.compact
	end

	def self.events
		@events ||= Hash.new { |h, k| h[k] = [] }
	end

	def self.on(name, selector = nil, method = nil, &block)
		if block
			events[name] << [selector, block]
		elsif method
			events[name] << [selector, method]
		else
			events[name] << [nil, selector]
		end
	end

	def self.off(id)
		name, selector, block = id

		events[name].delete([selector, block])
	end

	def self.render(&block)
		define_method :render do
			instance_exec(&block)

			super()
		end
	end

	def self.html(string = nil, &block)
		if block
			render {
				if block.arity == 1
					element.inner_dom { |d|
						instance_exec(d, &block)
					}
				else
					element.inner_dom(&block)
				end
			}
		else
			render {
				element.inner_html = string
			}
		end
	end

	def self.text(string = nil, &block)
		if block
			render {
				element.inner_text = instance_exec(&block)
			}
		else
			render {
				element.inner_text = string
			}
		end
	end

	def self.css!(content = nil, &block)
		if content || block
			@global.remove if @global

			@global = CSS(content, &block)
			@global.append_to($document.head)
		else
			CSS::StyleSheet.new(@global) if @global
		end
	end

	def self.css(&block)
		if block
			selector = if @tag && id = @tag[:id]
				"##{id}"
			elsif @tag && cls = @tag[:class]
				".#{Array(cls).join('.')}"
			elsif @element
				@element
			elsif self.name
				".#{self.name.gsub(/::/, '-').downcase}"
			else
				".lissio-#{object_id}"
			end

			@local.remove if @local

			@local = CSS do
				rule selector do
					if block.arity == 0
						instance_exec(&block)
					else
						block.call(self)
					end
				end
			end

			@local.append_to($document.head)
		else
			CSS::StyleSheet.new(@local) if @local
		end
	end

	def tag
		{ name: :div }.merge(self.class.tag || {})
	end

	def parent
		@__parent__
	end

	def parent=(value)
		@__parent__ = value
	end

	def element
		return @__element__ if @__element__

		scope = parent ? parent.element : $document
		elem  = if elem = self.class.element
			scope.at(elem)
		else
			DOM::Element.create tag[:name]
		end

		unless elem
			raise ArgumentError, 'element not found'
		end

		elem.add_class(*tag[:class]) if tag[:class]
		elem.add_class(*self.class.inheritance)

		tag.each {|name, value|
			if name != :class && name != :name
				elem[name] = value
			end
		}

		[self.class.events, @__events__].compact.each {|events|
			events.each {|name, blocks|
				blocks.each {|selector, block|
					if Symbol === block
						elem.on name, selector do |*args|
							__send__ block, *args
						end
					else
						elem.on name, selector do |*args|
							instance_exec(*args, &block)
						end
					end
				}
			}
		}

		@__element__ = elem
	end

	def on(name, selector = nil, method = nil, &block)
		if @__element__
			if block
				@__element__.on name, selector do |*args|
					instance_exec(*args, &block)
				end
			elsif method
				@__element__.on name, selector do |*args|
					__send__ method, *args
				end
			else
				@__element__.on name do |*args|
					__send__ method, *args
				end
			end
		else
			@__events__ ||= Hash.new { |h, k| h[k] = [] }

			if block
				@__events[__name] << [selector, block]
			elsif method
				@__events__[name] << [selector, method]
			else
				@__events__[name] << [nil, selector]
			end
		end
	end

	# When overriding, remember to call super as last.
	def render(*)
		element.trigger! :render, self
		element
	end

	def trigger(*args, &block)
		element.trigger(*args, &block)
		self
	end

	def trigger!(*args, &block)
		element.trigger!(*args, &block)
		self
	end

	def remove
		@__element__.remove if @__element__
	end

	alias destroy remove
end

Browser::DOM::Builder.for Component do |_, item|
	item.render
end

end
