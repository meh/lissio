require 'opal'

require 'lissio/version'
require 'lissio/server'

# Just register our opal code path with opal build tools
Opal.append_path File.expand_path('../../opal', __FILE__)
