require 'opal'
require 'lissio/version'

# Just register our opal code path with opal build tools
Opal.append_path File.expand_path('../../opal', __FILE__)
Opal.use_gem 'parslet'
Opal.use_gem 'blankslate'
