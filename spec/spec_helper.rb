if RUBY_VERSION >= '1.9.2' then
  require 'simplecov'
  SimpleCov.start if ENV['COVERAGE']
end

require 'qup'

require 'tmpdir'
def temp_dir( token, unique_id = Process.pid )
  dirname = File.join( Dir.tmpdir, "#{token}-#{unique_id}")
  FileUtils.mkdir_p( dirname ) unless File.directory?( dirname )
  # on osx the directory is different when you are in it than what it is when it
  # is created
  dirname = Dir.chdir( dirname ) { Dir.pwd }
  return dirname
end

RSpec.configure do |conf|
  Qup::KNOWN_ADAPTERS.each do |adapter, gemname|
    begin
      require "qup/adapter/#{adapter}"
    rescue LoadError => e
      warn "NOTICE:"
      warn "NOTICE: The tests for the '#{adapter}' will be skipped as the '#{gemname}' is not installed"
      warn "NOTICE:"
      warn "LoadError: #{e}"
      sym = adapter.to_sym
      conf.filter_run_excluding sym => true
    end
  end
end

