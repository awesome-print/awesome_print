$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'ap'

if RUBY_VERSION.to_f < 1.9
  require 'spec'
  require 'spec/autorun'
  require 'rubygems'

  Spec::Runner.configure do |config|
  end
end

def stub_dotfile!
  dotfile = File.join(ENV["HOME"], ".aprc")
  File.should_receive(:readable?).at_least(:once).with(dotfile).and_return(false)
end
