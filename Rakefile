# vim: syntax=ruby

begin
  require 'rubygems'
  require 'hoe'
rescue LoadError
  abort <<-_
  Developing qup requires the use of rubygems and hoe.

    gem install hoe
  _
end

Hoe.plugin :doofus, :git, :gemspec2

Hoe.spec 'qup' do
  developer 'Jeremy Hinegardner', 'jeremy@copiousfreetime.org'

  # Use rdoc for history and readme
  self.history_file = 'HISTORY.rdoc'
  self.readme_file  = 'README.rdoc'

  self.extra_rdoc_files = [ self.readme_file, self.history_file ]

  self.extra_dpes << [ 'maildir', '~> 2.0.0' ]

  # test with rspec
  self.extra_dev_deps << [ 'rspec', '~> 2.8.0']
  self.testlib = :rspec
  self.rspec_options = %w[ --color --format doc ]
  self.test_globs = 'spec/**/*_spec.rb'

end

