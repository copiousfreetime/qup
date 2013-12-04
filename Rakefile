# vim: syntax=ruby
require 'rubygems'
load 'tasks/this.rb'

This.name     = "qup"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  # The Runtime Dependencies
  spec.add_runtime_dependency( 'maildir', '~> 2.1.0' )

  # Additional functionality if used
  spec.add_development_dependency( 'kjess' , '~> 1.2' )
  spec.add_development_dependency( 'redis' , '~> 3.0' )

  # The Development Dependencies
  spec.add_development_dependency( 'rake'  , '~> 10.1.0' )
  spec.add_development_dependency( 'rspec' , '~> 2.14.0' )
  spec.add_development_dependency( 'rdoc'  , '~> 4.0'    )

end

load 'tasks/default.rake'
