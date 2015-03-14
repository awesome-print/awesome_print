module AwesomePrint
  module Formatters
    class SequelModelClass < Base

      def call
        data = object.db_schema.inject({}) {|h, (name,data)| h.merge(name => data[:db_type])}
        "class #{object} < #{object.superclass} " << AwesomePrint::Formatters::Hash.new(formatter, data).call
      end
    end
  end
end
