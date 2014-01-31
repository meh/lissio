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

	def initialize(&block)
		if block
			@content = Definer.new(&block).to_a
		else
			@content = []
		end
	end

	def render(*content, &block)
		content = @content.dup if content.empty?
		content.compact! # FIXME: when it's fixed

		element.clear

		content.each {|c|
			if Component === c
				element << c.render
			else
				element << c.to_s
			end
		}

		if block
			element << DOM(&block)
		end

		super
	end
end

end; end
