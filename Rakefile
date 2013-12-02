# vim: syntax=ruby
load 'tasks/this.rb'

This.name     = "qup"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"

This.ruby_gemspec do |spec|
  # The Runtime Dependencies
  spec.add_runtime_dependency( 'maildir', '~> 2.1.0' )

  # Additional functionality if used
  spec.add_development_dependency( 'kjess' , '~> 1.0.0' )
  spec.add_development_dependency( 'redis' , '~> 3.0.2' )

  # The Development Dependencies
  spec.add_development_dependency( 'rake'  , '~> 0.9.2.2')
  spec.add_development_dependency( 'rspec' , '~> 2.13.0' )
  spec.add_development_dependency( 'rdoc'  , '~> 3.12'   )

end

load 'tasks/default.rake'
