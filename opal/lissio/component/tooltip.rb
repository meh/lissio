module Lissio; class Component

class Tooltip < Lissio::Component
	DEFAULTS = {
		placement: :top,
		animate:   true,
		container: false,
		delay:     0,
		escape:    true
	}

	def initialize(*args, &block)
		if Lissio::Component === args.first
			super(args.shift)
		end

		@options = DEFAULTS.merge(args.first)
		@block   = block
		@enabled = true

		render
	end

	def enabled?
		@enabled
	end

	def enable
		@enabled = true
	end

	def disable
		@enabled = false
	end

	def shown?
		element.has_class? :in
	end

	def register(element, trigger)
		case trigger
		when :click
			element.on :click do
				toggle
			end

		when :hover
			element.on 'mouse:over' do
				show
			end

			element.on 'mouse:out' do
				hide
			end

		when :focus
			element.on :focus do
				show
			end

			element.on :blur do
				hide
			end
		end

		self
	end

	def show(content = @options[:content])
		return unless enabled?

		placement = @block ? block.call(self) : @options[:placement] || place

		element.detach
		element.style(top: 0, left: 0, display: 0)
		element.add_class placement, :in
		element.append_to container

		element.at('.tooltip-inner').content = content
		element.show()

		apply(placement)
	end

	def hide
		element.remove_class :in
	end

	def toggle
		if shown?
			hide
		else
			show
		end
	end

	def destroy

	end

private
	def container
		if container = @options[:container]
			if String === container
				container = (parent ? parent.element : $document).at(container)
			end

			container
		else
			parent ? parent.element : $document.body
		end
	end

	def along
		if along = @options[:along]
			if String === along
				along = (parent ? parent.element : $document).at(along)
			end

			along
		else
			raise ArgumentError, "no parent or along"

			parent.element
		end
	end

	def offset(placement)
		along_position = along.position
		along_size     = along.size
		size           = element.size

		case placement
		when :bottom
			Browser::Position.new(along_position.x + (along_size.width / 2) - (size.width / 2),
			                      along_position.y + along_size.height)

		when :top
			Browser::Position.new(along_position.x + (along_size.width / 2) - (size.width / 2),
			                      along_position.y - size.height)

		when :left
			Browser::Position.new(along_position.x - size.width,
			                      along_position.y + (along_size.height / 2) - (size.height / 2))

		when :right
			Browser::Position.new(along_position.x + along_size.width,
			                      along_position.y + (along_size.height / 2) - (size.height / 2))
		end
	end

	def apply(placement)
		position = offset(placement)
		size     = element.size

		margin_top  = element.style['margin-top'].to_u
		margin_left = element.style['margin-left'].to_u

		element.offset = position.x + margin_top, position.y + margin_left
	end

	def place
		:top
	end

	tag class: :tooltip

	html do
		div.tooltip[:arrow]
		div.tooltip[:inner]
	end

	css do
		rule '.tooltip' do
			position :absolute
			z index: 9001

			display :block
			visibility :visible

			font size: 12.px
			line height: 1.4

			opacity 0

			rule '&.in' do
				opacity 0.9
			end

			rule '&.top' do
				margin top: -3.px
				padding 5.px, 0
			end

			rule '&.right' do
				margin left: 3.px
				padding 0, 5.px
			end

			rule '&.bottom' do
				margin top: 3.px
				padding 5.px, 0
			end

			rule '&.left' do
				margin left: -3.px
				padding 0, 5.px
			end

			rule '.tooltip-inner' do
				max width: 200.px
				padding 3.px, 8.px
				color '#fff'

				text align:      :center,
			       decoration: :none

				background color: '#000'
				border radius: 4.px
			end

			rule '.tooltip-arrow' do
				position :absolute
				width 0
				height 0

				border color: :transparent,
			         style: :solid
			end

			rule '&.top .tooltip-arrow' do
				bottom 0
				left 50.%

				margin left: -5.px
				border width: [5.px, 5.px, 0],
				       color: { top: '#000' }
			end

			rule '&.top-left .tooltip-arrow' do
				bottom 0
				left 5.px

				border width: [5.px, 5.px, 0],
				       color: { top: '#000' }
			end

			rule '&.top-right .tooltip-arrow' do
				bottom 0
				right 5.px

				border width: [5.px, 5.px, 0],
				       color: { top: '#000' }
			end

			rule '&.right .tooltip-arrow' do
				top 50.%
				left 0

				margin top: -5.px
				border width: [5.px, 5.px, 5.px, 0],
				       color: { right: '#000' }
			end

			rule '&.left .tooltip-arrow' do
				top 50.%
				right 0

				margin top: -5.px
				border width: [5.px, 0, 5.px, 5.px],
				       color: { left: '#000' }
			end

			rule '&.bottom .tooltip-arrow' do
				top 0
				left 50.%

				margin left: -5.px
				border width: [0, 5.px, 5.px],
				       color: { bottom: '#000' }
			end

			rule '&.bottom-left .tooltip-arrow' do
				top 0
				left 5.px

				border width: [0, 5.px, 5.px],
				       color: { bottom: '#000' }
			end

			rule '&.bottom-right .tooltip-arrow' do
				top 0
				right 5.px

				border width: [0, 5.px, 5.px],
				       color: { bottom: '#000' }
			end
		end
	end

	def self.customize(*args, &block)
		if args.length == 1
			options = args.first
		else
			name, options = args
		end

		name    ||= "tooltip-custom-#{rand(10000)}"
		options ||= {}

		Class.new(self) {
			tag class: [:tooltip, name]

			css do
				rule ".tooltip.#{name}" do
					instance_exec(&block) if block

					if value = options[:opacity]
						rule '&.in' do
							opacity value
						end
					end

					if value = options[:foreground] || options[:fg]
						rule '.tooltip-inner' do
							color value
						end
					end

					if value = options[:background] || options[:bg]
						rule '.tooltip-inner' do
							background color: value
						end

						rule '&.top .tooltip-arrow' do
							border color: { top: value }
						end

						rule '&.top-right .tooltip-arrow' do
							border color: { top: value }
						end

						rule '&.top-left .tooltip-arrow' do
							border color: { top: value }
						end

						rule '&.right .tooltip-arrow' do
							border color: { right: value }
						end

						rule '&.left .tooltip-arrow' do
							border color: { right: value }
						end

						rule '&.bottom .tooltip-arrow' do
							border color: { bottom: value }
						end

						rule '&.bottom-right .tooltip-arrow' do
							border color: { bottom: value }
						end

						rule '&.bottom-left .tooltip-arrow' do
							border color: { bottom: value }
						end
					end
				end
			end
		}
	end
end

end; end
