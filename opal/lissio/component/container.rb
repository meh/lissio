module Lissio; class Component

class Container < Component
	class Definer
		def initialize(&block)
			@list = []

			if block.arity == 0
				instance_exec(&block)
			else
				block.call(self)
			end
		end

		def render(what)
			@list << what
		end

		def to_a
			@list
		end
	end

	def initialize(parent, &block)
		super(parent)

		if block
			@content = Definer.new(&block).to_a
		else
			@content = []
		end
	end

	def render(*content)
		content = @content.dup if content.empty?
		content.compact! # FIXME: when it's fixed

		element.clear

		content.each {|c|
			if String === c
				element << c
			else
				element << (c.render; c.element)
			end
		}

		super
	end
end

end; end
