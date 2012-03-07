require 'minitest/spec'
require 'minitest/pride'
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
