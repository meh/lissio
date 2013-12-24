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

		domain options[:domain] || $document.location.host
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

	def endpoint(value = nil, &block)
		if value
			if Proc === value
				@endpoint = value
			elsif model?
				@endpoint = proc {|method, instance, id|
					case method
					when :fetch
						"#{value}/#{id}"

					when :save, :create, :destroy
						"#{value}/#{instance.id!}"
					end
				}
			else
				@endpoint = proc {|method, instance, desc|
					if method == :fetch
						"#{value}?#{desc.encode_uri}"
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

	def with(method, model, *args)
		point = @endpoint.call(method, model, *args)

		if Hash === point
			point.first[0].to_s.downcase
		end
	end

	def url(method, model, *args)
		point = @endpoint.call(method, model, *args)

		if Hash === point
			point = point.first[1]
		end

		"//#{domain}#{point}"
	end

	def install
		if model?
			@for.instance_eval {
				def self.fetch(*args)
					promise = Promise.new
					with    = adapter.with(:fetch, nil, *args) || :get
					url     = adapter.url(:fetch, nil, *args)

					Browser::HTTP.send(with, url) do |req|
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
					promise = Promise.new
					with    = adapter.with(:save, self) || :put
					url     = adapter.url(:save, self)

					Browser::HTTP.send(with, url, to_json) do |req|
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
					promise = Promise.new
					with    = adapter.with(:create, self) || :post
					url     = adapter.url(:create, self)

					Browser::HTTP.send(with, url, to_json) do |req|
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
					promise = Promise.new
					with    = adapter.with(:destroy, self) || :delete
					url     = adapter.url(:destroy, self)

					Browser::HTTP.send(with, url) do |req|
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
					promise = Promise.new
					fetched = fetched_with.empty? ? [id!] : fetched_with
					with    = adapter.with(:fetch, self, *fetched) || :get
					url     = adapter.url(:fetch, self, *fetched)

					Browser::HTTP.send(with, url) do |req|
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
					promise = Promise.new
					with    = adapter.with(:fetch, nil, *args)
					url     = adapter.url(:fetch, nil, *args)

					Browser::HTTP.send(with, url) do |req|
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
					promise = Promise.new
					with    = adapter.with(:fetch, self, *fetched_with) || :get
					url     = adapter.url(:fetch, self, *fetched_with)

					Browser::HTTP.send(with, url)  do |req|
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
