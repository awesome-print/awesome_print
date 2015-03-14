module AwesomePrint
  module Formatters
    module MongoMapper

      def initialize(*args)
        super(*args)
        apply_default_mongo_mapper_options
      end

      private

        def apply_default_mongo_mapper_options
          @options[:color][:assoc] ||= :greenish
          @options[:mongo_mapper]  ||= {
            :show_associations => false, # Display association data for MongoMapper documents and classes.
            :inline_embedded => false    # Display embedded associations inline with MongoMapper documents.
          }
        end
    end
  end
end
