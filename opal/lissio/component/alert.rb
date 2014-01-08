module Lissio; class Component

class Alert < Component
	def self.new!(message, options = {})
		new(message, options.merge({ escape: false }))
	end

	attr_reader :message, :options

	def initialize(message, options = {})
		@message = message
		@options = options
	end

	def render
		if @options[:escape] == false
			element.inner_html = @message
		else
			@message.each_line {|line|
				element << line
				element << DOM { br }
			}
		end

		super
	end

	tag class: :alert

	css do
		border 1.px, :solid, :transparent

		padding 15.px

		rule 'a' do
			font weight: :bold
		end
	end

	def self.customize(options, &block)
		Class.new(self) {
			css do
				if value = options[:background] || options[:bg]
					background color: value
				end

				if value = options[:foreground] || options[:fg]
					color value
				end

				if value = options[:border]
					border color: value
				end

				if value = options[:padding]
					padding value
				end

				if block.arity == 0
					instance_exec(&block)
				else
					block.call(self)
				end if block
			end
		}
	end

	Info = customize background: '#d9edf7',
	                 foreground: '#3a87ad',
	                 border:     '#bce8f1'

	Success = customize message:    "The operation was successful.",
	                    background: '#dff0d8',
	                    foreground: '#468847',
	                    border:     '#d6e9c6'

	Warning = customize message:    "Something might have gone wrong.",
	                    background: '#fcf8e3',
	                    foreground: '#c09853',
	                    border:     '#fbeed5'

	Danger = customize message:    "An unexpected error has occurred.",
	                   background: '#f2dede',
	                   foreground: '#b94a48',
	                   border:     '#eed3d7'
end

end; end
