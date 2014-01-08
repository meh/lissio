require 'browser/http'
require 'browser/effects'

module Lissio; class Component

class Autocomplete < Lissio::Component
	class Section < Lissio::Component
		class Options
			def initialize(&block)
				@key = :id

				if block.arity.nonzero?
					block.call(self)
				else
					instance_eval(&block)
				end
			end

			def title(value = nil)
				value ? @title = value : @title
			end

			def url(value = nil)
				value ? @url = value : @url
			end

			def key(value = nil)
				value ? @key = value : @key
			end

			def select(&block)
				block ? @select = block : @select
			end

			def css(&block)
				block ? @css = block : @css
			end

			def html(&block)
				block ? @html = block : @html
			end
		end

		tag class: :section

		on 'mouse:down', '.result' do |e|
			result = JSON.parse(e.target.child.data(:result))

			@select.call(result)
		end

		def initialize(title, results, key, input, select)
			@title   = title
			@results = results
			@key     = key
			@input   = input
			@select  = select
		end
	end

	def initialize(&block)
		@autocompleters = []

		if block.arity.nonzero?
			block.call(self)
		else
			instance_eval(&block)
		end
	end

	def section(&block)
		options = Section::Options.new(&block)

		section = Class.new(Section) do
			html do |_|
				_.div.title @title

				@results.each do |res|
					_.div.result do |_|
						_.div.data(result: res.to_json)

						if options.html
							instance_exec(_, res, &options.html)
						else
							_.div do
								from = res[@key].index(@input)
								to   = from + @input.length

								_.span    res[@key][0 .. from - 1] if from.nonzero?
								_.span.hl res[@key][from .. to - 1]
								_.span    res[@key][to .. -1]
							end
						end
					end
				end
			end

			css do
				rule '.result' do
					instance_eval(&options.css) if options.css
				end
			end
		end

		@autocompleters << {
			url:     options.url,
			title:   options.title,
			select:  options.select,
			key:     options.key,
			section: section
		}
	end

	def results
		element.at_css(".results")
	end

	def hint
		element.at_css(".hint")
	end

	def query
		element.at_css(".query")
	end

	on 'input', '.query' do |e|
		if query.value.empty?
			hide_completions
			next
		end

		remove_old_completions

		comps = @autocompleters.map do |ac|
			url = "#{ac[:url]}?q=#{query.value}"

			Browser::HTTP.get(url).then do |response|
				[ac, response]
			end
		end

		Promise.when(*comps).each do |ac, response|
			append_completions(ac, response.json)
		end
	end

	on 'key:down', '.query' do |e|
		set_completion(@cur, @cur_ac) if e.key.eql?(:Tab)
	end

	on :blur, '.query' do
		hide_completions
	end

	def set_completion(comp, ac)
		key    = ac[:key]
		select = ac[:select]

		query.value = comp[key]
		select.call(comp)
	end

	def hide_completions
		hint.value = ''
		results.hide
	end

	def remove_old_completions
		@some_results = false
		@cur          = nil
		hint.value   = ''

		results.children.each do |child|
			results.remove_child(child)
		end
	end

	def set_hint(comps, ac)
		return unless hint.value.empty?

		key = ac[:key]

		if comps.first[key].downcase.start_with?(query.value)
			hint.value = query.value + comps.first[key][query.value.size .. -1]

			@cur    = comps.first
			@cur_ac = ac
		else
			hint.value = ''
		end
	end

	def append_completions(ac, comps)
		if comps.empty?
			hide_completions unless @some_results
			return
		end

		title   = ac[:title]
		select  = ac[:select]
		section = ac[:section]
		key     = ac[:key]
		input   = query.value

		@some_results = true

		if @cur.nil?
			@cur    = comps.first
			@cur_ac = ac
		end

		set_hint(comps, ac)

		results << section.new(title, comps, key, input, select).render
		results.show
	end

	tag class: :autocomplete

	html do
		input.hint
		input.query

		div.results
	end

	css do
		position :relative
		display :table
		margin 0.px, :auto

		rule '> *' do
			font size: 16.px;
			border 1.px, :solid, :black
			width 400.px
		end

		rule '.hint' do
			padding 6.px, 12.px
			color :grey
			display :block
		end

		rule '.query' do
			position :absolute
			top 0.px
			padding 6.px, 12.px
			background color: :transparent
		end

		rule '.results' do
			position :absolute
			top 32.px
			display :none
			border top: 0.px;
			width 424.px;
			background color: :white

			rule '.title' do
				padding 4.px
				text align: :center
				border top: [1.px, :solid, :black], bottom: [1.px, :solid, :black]
			end

			rule '.result' do
				padding 4.px, 12.px
				cursor :pointer

				rule '*' do
					pointer events: :none
				end

				rule 'span.hl' do
					font weight: :bold
				end
			end

			rule '.result:hover' do
				background color: :black
				color :white
			end
		end
	end
end
end; end

