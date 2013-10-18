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
	attr_accessor :domain, :endpoint, :block

	def initialize(model, options, &block)
		super(model)

		@domain   = options[:domain] || $document.location.host
		@endpoint = options[:endpoint] || endpoint_for(model)
		@block    = block
	end

	def url
		"//#{domain}#{endpoint}"
	end

	def install
		@model.instance_eval {
			def self.fetch(id, &block)
				Browser::HTTP.get "#{adapter.url}/#{id}" do |req|
					adapter.block.call(req) if adapter.block

					req.on :success do |res|
						block.call(new(res.json))
					end

					req.on :failure do |res|
						block.call(res.status)
					end
				end
			end

			def save(&block)
				Browser::HTTP.put "#{adapter.url}/#{id!}", to_json do |req|
					adapter.block.call(req) if adapter.block

					req.on :success do |res|
						block.call(res.status)
					end

					req.on :failure do |res|
						block.call(res.status)
					end
				end
			end

			def create(&block)
				Browser::HTTP.post adapter.url, to_json do |req|
					adapter.block.call(req) if adapter.block

					req.on :success do |res|
						block.call(res.status)
					end

					req.on :failure do |res|
						block.call(res.status)
					end
				end
			end

			def destroy(&block)
				Browser::HTTP.delete "#{adapter.url}/#{id!}" do |req|
					adapter.block.call(req) if adapter.block

					req.on :success do |res|
						block.call(res.status)
					end

					req.on :failure do |res|
						block.call(res.status)
					end
				end
			end
		}
	end

	def uninstall
		@model.instance_eval {
			class << self
				remove_method :fetch
			end

			remove_method :save
			remove_method :create
			remove_method :destroy
		}
	end

private
	def endpoint_for(klass)
		klass.name.match(/([^:]+)$/) {|m|
			"/#{m[1].downcase}"
		}
	end
end

end; end
