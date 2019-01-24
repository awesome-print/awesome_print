require_relative '../spec_helper'

RSpec.describe 'AwesomePrint' do
  describe 'Struct' do
    before do
      @struct = unless defined?(Struct::SimpleStruct)
        Struct.new('SimpleStruct', :name, :address).new
      else
        Struct::SimpleStruct.new
      end
      @struct.name = 'Herman Munster'
      @struct.address = '1313 Mockingbird Lane'
    end

    it 'empty struct' do
      expect(Struct.new('EmptyStruct').ai).to eq("\e[1;33mStruct::EmptyStruct < Struct\e[0m")
    end

    it 'plain multiline' do
      s1 = <<-EOS.strip
    address = \"1313 Mockingbird Lane\",
    name = \"Herman Munster\"
EOS
      s2 = <<-EOS.strip
    name = \"Herman Munster\",
    address = \"1313 Mockingbird Lane\"
EOS
      expect(@struct.ai(plain: true)).to satisfy { |out| out.match(s1) || out.match(s2) }
    end

    it 'plain multiline indented' do
      s1 = <<-EOS.strip
 address = "1313 Mockingbird Lane",
 name = "Herman Munster"
EOS
      s2 = <<-EOS.strip
 name = "Herman Munster",
 address = "1313 Mockingbird Lane"
EOS
      expect(@struct.ai(plain: true, indent: 1)).to satisfy { |out| out.match(s1) || out.match(s2) }
    end

    it 'plain single line' do
      s1 = 'address = "1313 Mockingbird Lane", name = "Herman Munster"'
      s2 = 'name = "Herman Munster", address = "1313 Mockingbird Lane"'
      expect(@struct.ai(plain: true, multiline: false)).to satisfy { |out| out.match(s1) || out.match(s2) }
    end

    it 'colored multiline (default)' do
      s1 = <<-EOS.strip
    address\e[0;37m = \e[0m\e[0;33m\"1313 Mockingbird Lane\"\e[0m,
    name\e[0;37m = \e[0m\e[0;33m\"Herman Munster\"\e[0m
EOS
      s2 = <<-EOS.strip
    name\e[0;37m = \e[0m\e[0;33m\"Herman Munster\"\e[0m,
    address\e[0;37m = \e[0m\e[0;33m\"1313 Mockingbird Lane\"\e[0m
EOS
      expect(@struct.ai).to satisfy { |out| out.include?(s1) || out.include?(s2) }
    end
  end
end
