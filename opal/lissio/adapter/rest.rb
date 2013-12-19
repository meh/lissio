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
			if model?
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

	def url(method, model, *args)
		"//#{domain}#{@endpoint.call(method, model, *args)}"
	end

	def install
		if model?
			@for.instance_eval {
				def self.fetch(*args, &block)
					Browser::HTTP.get adapter.url(:fetch, nil, *args) do |req|
						req.on :success do |res|
							block.call(new(res.json, *args))
						end

						req.on :failure do |res|
							block.call(res.status)
						end

						adapter.http.call(req) if adapter.http
					end
				end

				def save(&block)
					Browser::HTTP.put adapter.url(:save, self), to_json do |req|
						req.on :success do |res|
							block.call(res.status) if block
						end

						req.on :failure do |res|
							block.call(res.status) if block
						end

						adapter.http.call(req) if adapter.http
					end
				end

				def create(&block)
					Browser::HTTP.post adapter.url(:create, self), to_json do |req|
						req.on :success do |res|
							block.call(res.status) if block
						end

						req.on :failure do |res|
							block.call(res.status) if block
						end

						adapter.http.call(req) if adapter.http
					end
				end

				def destroy(&block)
					Browser::HTTP.delete adapter.url(:destroy, self) do |req|
						req.on :success do |res|
							block.call(res.status) if block
						end

						req.on :failure do |res|
							block.call(res.status) if block
						end

						adapter.http.call(req) if adapter.http
					end
				end

				def reload(&block)
					with = fetched_with.empty? ? [id!] : fetched_with

					Browser::HTTP.get adapter.url(:fetch, self, *with) do |req|
						req.on :success do |res|
							initialize(res.json, *fetched_with)
							block.call(self) if block
						end

						req.on :failure do |res|
							block.call(res.status) if block
						end

						adapter.http.call(req) if adapter.http
					end
				end
			}
		else
			@for.instance_eval {
				def self.fetch(*args, &block)
					Browser::HTTP.get adapter.url(:fetch, nil, *args) do |req|
						req.on :success do |res|
							block.call(new(res.json, *args)) if block
						end

						req.on :failure do |res|
							block.call(res.status) if block
						end

						adapter.http.call(req) if adapter.http
					end
				end

				def reload(&block)
					Browser::HTTP.get adapter.url(:fetch, self, *fetched_with) do |req|
						req.on :success do |res|
							initialize(res.json, *fetched_with)
							block.call(self)
						end

						req.on :failure do |res|
							block.call(res.status)
						end

						adapter.http.call(req) if adapter.http
					end
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
