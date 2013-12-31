# -*- encoding: utf-8 -*-
$LOAD_PATH << File.expand_path('../opal', __FILE__)
require 'lissio/version'

Gem::Specification.new do |s|
	s.name         = 'lissio'
	s.version      = Lissio::VERSION
	s.author       = 'meh.'
	s.email        = 'meh@schizofreni.co'
	s.homepage     = 'https://github.com/meh/lissio'
	s.summary      = '.'
	s.description  = '..'
	
	s.files          = `git ls-files`.split("\n")
	s.executables    = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
	s.test_files     = `git ls-files -- {test,spec,features}/*`.split("\n")
	s.require_paths  = ['lib']

  s.add_dependency 'opal', '>= 0.6.0'
	s.add_dependency 'opal-browser'
	s.add_dependency 'rack'

	s.add_development_dependency 'opal-spec'
	s.add_development_dependency 'rake'

	s.add_dependency 'thor'
end
