module AwesomePrint
  class Support

    def self.constantize(camel_cased_word)
      names = camel_cased_word.split('::')
      # Trigger a built-in NameError exception including the ill-formed constant in the message.
      Object.const_get(camel_cased_word) if names.empty?
      # Remove the first blank element in case of '::ClassName' notation.
      names.shift if names.size > 1 && names.first.empty?
      names.inject(Object) do |constant, name|
        if constant == Object
          constant.const_get(name)
        else
          candidate = constant.const_get(name)
          next candidate if constant.const_defined?(name, false)
          next candidate unless Object.const_defined?(name)
          # Go down the ancestors to check if it is owned directly. The check
          # stops when we reach Object or the end of ancestors tree.
          constant = constant.ancestors.inject do |const, ancestor|
            break const if ancestor == Object
            break ancestor if ancestor.const_defined?(name, false)
            const
          end
          # owner is in Object, so raise
          constant.const_get(name, false)
        end
      end
    end

    def self.camelize(term)
      term = term.capitalize
      term.gsub(/(?:_|(\/))([a-z\d]*)/i) {  $2.capitalize }
    end
  end
end
