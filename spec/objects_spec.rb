require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Single method" do
  before do
    stub_dotfile!
  end

  after do
    Object.instance_eval{ remove_const :Hello } if defined?(Hello)
  end

  describe "object" do
    it "attributes" do
      class Hello
        attr_reader   :abra
        attr_writer   :ca
        attr_accessor :dabra

        def initialize
          @abra, @ca, @dabra = 1, 2, 3
        end
      end

      out = Hello.new.ai(:plain => true)
      str = <<-EOS.strip
#<Hello:0x01234567
    attr_accessor :dabra = 3,
    attr_reader :abra = 1,
    attr_writer :ca = 2
>
EOS
      out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
    end

    it "instance variables" do
      class Hello
        def initialize
          @abra, @ca, @dabra = 1, 2, 3
        end
      end

      out = Hello.new.ai(:plain => true)
      str = <<-EOS.strip
#<Hello:0x01234567
    @abra = 1,
    @ca = 2,
    @dabra = 3
>
EOS
      out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
    end

    it "attributes and instance variables" do
      class Hello
        attr_reader   :abra
        attr_writer   :ca
        attr_accessor :dabra

        def initialize
          @abra, @ca, @dabra = 1, 2, 3
          @scooby, @dooby, @doo = 3, 2, 1
        end
      end

      out = Hello.new.ai(:plain => true)
      str = <<-EOS.strip
#<Hello:0x01234567
    @doo = 1,
    @dooby = 2,
    @scooby = 3,
    attr_accessor :dabra = 3,
    attr_reader :abra = 1,
    attr_writer :ca = 2
>
EOS
      out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
    end
  end
end
