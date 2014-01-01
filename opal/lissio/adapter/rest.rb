#--
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#                    Version 2, December 2004
#
#            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
#   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
#
#  0. You just DO WHAT THE FUCK YOU WANT TO.
#++

require 'browser/location'
require 'browser/http'
require 'promise'

module Lissio; class Adapter

class REST < Adapter
	def initialize(value, options = {}, &block)
		super(value)

		domain   options[:domain]
		base     options[:base]
		endpoint options[:endpoint] || endpoint_for(value)

		if block.arity == 0
			instance_exec(&block)
		else
			block.call(self)
		end if block
	end

	def domain(value = nil)
		value ? @domain = value : @domain
	end

	def base(value = nil)
		value ? @base = value : @base
	end

	def endpoint(value = nil, &block)
		if value
			if Proc === value || Hash === value
				@endpoint = value
			elsif model?
				@endpoint = proc {|method, *args|
					next value if args.empty?

					case method
					when :fetch
						"#{value}/#{args.first}"

					when :save, :create, :destroy
						"#{value}/#{args.first.id!}"
					end
				}
			else
				@endpoint = proc {|method, *args|
					if method == :fetch
						if desc = args.first
							"#{value}?#{desc.encode_uri}"
						else
							value
						end
					end
				}
			end
		elsif block
			@endpoint = block
		else
			@endpoint
		end
	end

	def http(&block)
		block ? @http = block : @http
	end

	def to(method, *args)
		result = if Proc === @endpoint
			@endpoint.call(method, *args)
		else
			@endpoint[method].call(*args)
		end

		if Hash === result
			with, point = result.first
		else
			point = result
		end

		url = if @base
			"#@base#{point}"
		elsif @domain
			"//#@domain#{point}"
		else
			"//#{$document.location.host}#{point}"
		end

		if with
			[url, with]
		else
			url
		end
	end

	def install
		if model?
			@for.instance_eval {
				def self.fetch(*args)
					promise   = Promise.new
					url, with = adapter.to(:fetch, *args)

					Browser::HTTP.send(with || :get, url) do |req|
						req.on :success do |res|
							promise.resolve(new(res.json, *args))
						end

						req.on :failure do |res|
							promise.reject(res.status)
						end

						adapter.http.call(req) if adapter.http
					end

					promise
				end

				def save
					promise   = Promise.new
					url, with = adapter.to(:save, self)

					Browser::HTTP.send(with || :put, url, to_json) do |req|
						req.on :success do |res|
							promise.resolve(res.status)
						end

						req.on :failure do |res|
							promise.reject(res.status)
						end

						adapter.http.call(req) if adapter.http
					end

					promise
				end

				def create
					promise   = Promise.new
					url, with = adapter.to(:create, self)

					Browser::HTTP.send(with || :post, url, to_json) do |req|
						req.on :success do |res|
							promise.resolve(res.status)
						end

						req.on :failure do |res|
							promise.reject(res.status)
						end

						adapter.http.call(req) if adapter.http
					end

					promise
				end

				def destroy
					promise   = Promise.new
					url, with = adapter.to(:destroy, self)

					Browser::HTTP.send(with || :delete, url) do |req|
						req.on :success do |res|
							promise.resolve(res.status)
						end

						req.on :failure do |res|
							promise.reject(res.status)
						end

						adapter.http.call(req) if adapter.http
					end

					promise
				end

				def reload
					promise   = Promise.new
					fetched   = fetched_with.empty? ? [id!] : fetched_with
					url, with = adapter.to(:fetch, self, *fetched)

					Browser::HTTP.send(with || :get, url) do |req|
						req.on :success do |res|
							initialize(res.json, *fetched_with)

							promise.resolve(self)
						end

						req.on :failure do |res|
							promise.reject(res.status)
						end

						adapter.http.call(req) if adapter.http
					end

					promise
				end
			}
		else
			@for.instance_eval {
				def self.fetch(*args, &block)
					promise   = Promise.new
					url, with = adapter.to(:fetch, *args)

					Browser::HTTP.send(with || :get, url) do |req|
						req.on :success do |res|
							promise.resolve(new(res.json, *args))
						end

						req.on :failure do |res|
							promise.reject(res.status)
						end

						adapter.http.call(req) if adapter.http
					end

					promise
				end

				def reload(&block)
					promise   = Promise.new
					url, with = adapter.to(:fetch, self, *fetched_with)

					Browser::HTTP.send(with || :get, url)  do |req|
						req.on :success do |res|
							initialize(res.json, *fetched_with)
							promise.resolve(self)
						end

						req.on :failure do |res|
							promise.reject(res.status)
						end

						adapter.http.call(req) if adapter.http
					end

					promise
				end
			}
		end
	end

	def uninstall
		if model?
			@for.instance_eval {
				class << self
					remove_method :fetch
				end

				remove_method :save
				remove_method :create
				remove_method :destroy
				remove_method :reload
			}
		else
			@for.instance_eval {
				class << self
					remove_method :fetch
				end

				remove_method :reload
			}
		end
	end

private
	def endpoint_for(klass)
		klass.name.match(/([^:]+)$/) {|m|
			"/#{m[1].downcase}"
		}
	end
end

end; end
