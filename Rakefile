# vim: syntax=ruby

This.name     = "qup"
This.author   = "Jeremy Hinegardner"
This.email    = "jeremy@copiousfreetime.org"
This.homepage = "http://github.com/copiousfreetime/#{ This.name }"
This.version  = Util.version

#------------------------------------------------------------------------------
# If you want to Develop on qup just run 'rake develop' and you'll have all you
# need to get going. If you want to use bundler for development, then run
# 'rake develop:using_bundler'
#------------------------------------------------------------------------------
namespace :develop do
  task :default do
    require 'rubygems/dependency_installer'
    installer = Gem::DependencyInstaller.new

    puts "Installing gem depedencies needed for development"
    This.gemspec.dependencies.each do |dep|
      if dep.matching_specs.empty? then
        puts "Installing : #{dep}"
        installer.install dep
      else
        puts "Skipping   : #{dep} -> already installed #{dep.matching_specs.first.full_name}"
      end
    end
    puts "\n\nNow run 'rake test'"
  end

  file 'Gemfile' => :gemspec do
    File.open( "Gemfile", "w+" ) do |f|
      f.puts 'source :rubygems'
      f.puts 'gemspec'
    end
  end

  desc "Create a bundler Gemfile"
  task :using_bundler => 'Gemfile' do
    puts "Now you can 'bundle'"
  end
  CLOBBER << FileList['Gemfile*']
end
desc "Boostrap development"
task :develop => "develop:default"

#------------------------------------------------------------------------------
# RSpec
#------------------------------------------------------------------------------
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new( :test ) do |t|
    t.ruby_opts    = %w[ -w ]
    t.rspec_opts   = %w[ --color --format documentation ]
  end
  task :default => :test
rescue LoadError
  Util.task_warning( 'test' )
end

#------------------------------------------------------------------------------
# RDoc
#------------------------------------------------------------------------------
begin
  gem 'rdoc' # otherwise we get the wrong task from stdlib
  require 'rdoc/task'
  RDoc::Task.new do |t|
    t.markup   = 'tomdoc'
    t.rdoc_dir = 'doc'
    t.main     = 'README.rdoc'
    t.title    = "#{This.name} #{This.version}"
    t.rdoc_files.include( '*.rdoc', 'lib/**/*.rb' )
  end
rescue LoadError
  Util.task_warning( 'rdoc' )
end

#------------------------------------------------------------------------------
# Coverage
#------------------------------------------------------------------------------
begin
  require 'rcov/rcovtask'
  Rcov::RcovTask.new do |t|
    t.libs      << 'spec'
    t.pattern   = 'spec/**/*_spec.rb'
    t.verbose   = true
    t.rcov_opts << "-x ^/"           # remove all the global files
    t.rcov_opts << "--sort coverage" # so we see the worst files at the top
  end
rescue LoadError
  Util.task_warning( 'rcov' )
end

#------------------------------------------------------------------------------
# Manifest - most of this is from Hoe
#------------------------------------------------------------------------------
namespace 'manifest' do
  desc "Check the manifest"
  task :check => :clean do
    files = FileList["**/*", ".*"].exclude( This.exclude_from_manifest ).to_a.sort
    files = files.select{ |f| File.file?( f ) }

    tmp = "Manifest.tmp"
    File.open( tmp, 'w' ) do |f|
      f.puts files.join("\n")
    end

    begin
      sh "diff -du Manifest.txt #{tmp}"
    ensure
      rm tmp
    end
    puts "Manifest looks good"
  end

  desc "Generate the manifest"
  task :generate => :clean do
    files = %x[ git ls-files ].split("\n").sort
    files.reject! { |f| f =~ This.exclude_from_manifest }
    File.open( "Manifest.txt", "w" ) do |f|
      f.puts files.join("\n")
    end
  end
end

#------------------------------------------------------------------------------
# Gem Specification
#------------------------------------------------------------------------------
This.gemspec = Gem::Specification.new do |spec|
  spec.name        = This.name
  spec.version     = This.version
  spec.author      = This.author
  spec.email       = This.email
  spec.homepage    = This.homepage

  spec.summary     = This.summary
  spec.description = This.description

  spec.files       = This.manifest
  spec.executables = spec.files.grep(/^bin/) { |f| File.basename(f) }
  spec.test_files  = spec.files.grep(/^spec/)

  spec.extra_rdoc_files += spec.files.grep(/(txt|rdoc)$/)
  spec.rdoc_options = [ "--main"  , 'README.rdoc',
                        "--markup", "tomdoc" ]

  # The Runtime Dependencies
  spec.add_runtime_dependency( 'maildir', '~> 2.0.0' )

  # Additional functionality if used
  spec.add_development_dependency( 'kestrel-client'  , '~> 0.7.1' )
  spec.add_development_dependency( 'redis'           , '~> 2.2.2' )
  spec.add_development_dependency( 'SystemTimer'     , '~> 1.2.3' )

  # The Development Dependencies
  spec.add_development_dependency( 'rake'  , '~> 0.9.2.2')
  spec.add_development_dependency( 'rcov'  , '~> 1.0.0'  )
  spec.add_development_dependency( 'rspec' , '~> 2.8.0'  )
  spec.add_development_dependency( 'rdoc'  , '~> 3.12'   )

end
This.gemspec_file = "#{This.name}.gemspec"

desc "Build the #{This.name}.gemspec file"
task :gemspec do
  File.open( This.gemspec_file, "wb+" ) do |f|
    f.write This.gemspec.to_ruby
  end
end
CLOBBER << This.gemspec_file

require 'rubygems/package_task'
Gem::PackageTask.new( This.gemspec ) do
  # nothing
end

#------------------------------------------------------------------------------
# Release
#------------------------------------------------------------------------------
task :release_check do
  unless `git branch` =~ /^\* master$/
    abort "You must be on the master branch to release!"
  end
  unless `git status` =~ /^nothing to commit/m
    abort "Nope, sorry, you have unfinished business"
  end
end

desc "Create tag v#{This.version}, build and push #{This.gemspec.full_name} to rubygems.org"
task :release => [ :release_check, 'manifest:check', :gem ] do
  sh "git commit --allow-empty -a -m 'Release #{This.version}'"
  sh "git tag -a -m 'v#{This.version}' v#{This.version}"
  sh "git push origin master"
  sh "git push origin v#{This.version}"
  sh "gem push pkg/#{This.gemspec.full_name}.gem"
end

#------------------------------------------------------------------------------
# Rakefile Support
#------------------------------------------------------------------------------
BEGIN {

  require 'ostruct'
  require 'rake/clean'
  require 'rubygems' unless defined? Gem

  module Util
    def self.version
      line = File.read( "lib/#{ This.name }.rb" )[/^\s*VERSION\s*=\s*.*/]
      line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
    end

    # Partition an rdoc file into sections and return the text of the section
    # as an array of paragraphs
    def self.section_of( file, section_name )
      re    = /^=+ (.*)$/
      parts = File.read( file ).split( re )[1..-1]
      parts.map! { |p| p.strip }

      sections = Hash.new
      Hash[*parts].each do |k,v|
        sections[k] = v.split("\n\n")
      end
      return sections[section_name]
    end

    def self.task_warning( task )
      warn "WARNING: '#{task}' tasks are not defined. Please run 'rake develop'"
    end

    def self.read_manifest
      abort "You need a Manifest.txt" unless File.readable?( "Manifest.txt" )
      File.readlines( "Manifest.txt" ).map { |l| l.strip }
    end
  end

  # Hold all the metadata about this project
  This = OpenStruct.new
  desc = Util.section_of( 'README.rdoc', 'DESCRIPTION')
  This.summary     = desc.first
  This.description = desc.join(" ").tr("\n", ' ').gsub(/[{}]/,'').gsub(/\[[^\]]+\]/,'') # strip rdoc


  This.exclude_from_manifest = %r/tmp$|\.(git|DS_Store)|^(doc|coverage|pkg)|\.gemspec$|\.swp$|\.jar|\.rvmrc$|~$/
  This.manifest = Util.read_manifest

}
