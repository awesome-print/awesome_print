module AwesomePrint
  module Formatters
    Dir[File.join(__dir__, 'formatters', '**', '*.rb')].each { |f| require f }
  end
end

