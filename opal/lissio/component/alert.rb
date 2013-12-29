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
		rule '.alert' do
			border 1.px, :solid, :transparent

			padding 15.px

			rule 'a' do
				font weight: :bold
			end
		end
	end

	def self.customize(*args, &block)
		if args.length == 1
			options = args.first
		else
			name, options = args
		end

		name    ||= "alert-custom-#{rand(10000)}"
		options ||= {}

		if self == Alert
			inherited = []
		else
			inherited = class_names
		end

		Class.new(self) {
			define_singleton_method :class_names do
				inherited + [name]
			end

			tag class: [:alert, name, *inherited]

			css do
				rule ".alert#{".#{inherited.join('.')}" unless inherited.empty?}.#{name}" do
					instance_exec(&block) if block

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
				end
			end
		}
	end

	Info = customize :info,
		background: '#d9edf7',
		foreground: '#3a87ad',
		border:     '#bce8f1'

	Success = customize :success,
		message:    "The operation was successful.",
		background: '#dff0d8',
		foreground: '#468847',
		border:     '#d6e9c6'

	Warning = customize :warning,
		message:    "Something might have gone wrong.",
		background: '#fcf8e3',
		foreground: '#c09853',
		border:     '#fbeed5'

	Danger = customize :danger,
		message:    "An unexpected error has occurred.",
		background: '#f2dede',
		foreground: '#b94a48',
		border:     '#eed3d7'
end

end; end
