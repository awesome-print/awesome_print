require_relative '../spec_helper'

RSpec.describe 'AwesomePrint' do

  describe 'Class' do
    it 'should show superclass (plain)' do
      expect(self.class.ai(plain: true)).to eq("#{self.class} < #{self.class.superclass}")
    end

    it 'should show superclass (color)' do
      expect(self.class.ai).to eq("#{self.class} < #{self.class.superclass}".yellow)
    end
  end

  describe 'Inherited from standard Ruby classes' do
    after do
      Object.instance_eval { remove_const :My } if defined?(My)
    end

    it 'should handle a class that defines its own #send method' do
      class My
        def send(arg1, arg2, arg3); end
      end

      my = My.new
      expect { my.methods.ai(plain: true) }.not_to raise_error
    end

    it 'should handle a class defines its own #method method (ex. request.method)' do
      class My
        def method
          'POST'
        end
      end

      my = My.new
      expect { my.methods.ai(plain: true) }.not_to raise_error
    end

    describe 'should handle a class that defines its own #to_hash method' do
      it 'that takes arguments' do
        class My
          def to_hash(a, b)
          end
        end

        my = My.new
        expect { my.ai(plain: true) }.not_to raise_error
      end

      it 'that returns nil' do
        class My
          def to_hash()
            return nil
          end
        end

        my = My.new
        expect { my.ai(plain: true) }.not_to raise_error
      end

      it "that returns an object that doesn't support #keys" do
        class My
          def to_hash()
            object = Object.new
            object.define_singleton_method('[]') { return nil }

            return object
          end
        end

        my = My.new
        expect { my.ai(plain: true) }.not_to raise_error
      end

      it "that returns an object that doesn't support subscripting" do
        class My
          def to_hash()
            object = Object.new
            object.define_singleton_method(:keys) { return [:foo] }

            return object
          end
        end

        my = My.new
        expect { my.ai(plain: true) }.not_to raise_error
      end
    end
  end
end
