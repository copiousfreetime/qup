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

# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :inline
# Hoe.plugin :racc
# Hoe.plugin :rubyforge

Hoe.spec 'qup' do
  developer 'Jeremy Hinegardner', 'jeremy@copiousfreetime.org'

  # Use rdoc for history and readme
  self.history_file = 'HISTORY.rdoc'
  self.readme_file  = 'README.rdoc'

  self.extra_rdoc_files = [ self.readme_file, self.history_file ]

  # test with minitest
  self.extra_dev_deps << [ 'minitest', '~> 2.0.2']
  self.testlib = :minitest

end

