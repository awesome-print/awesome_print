require_relative '../spec_helper'

RSpec.describe 'AwesomePrint' do

  #------------------------------------------------------------------------------
  describe 'Limited Output Hash' do
    before(:each) do
      @hash = ('a'..'z').inject({}) { |h, v| h.merge({ v => v.to_sym }) }
    end

    it 'plain limited output' do
      expect(@hash.ai(sort_keys: true, plain: true, limit: true)).to eq <<-EOS.strip
{
    "a" => :a,
    "b" => :b,
    "c" => :c,
    "d" => :d .. "w" => :w,
    "x" => :x,
    "y" => :y,
    "z" => :z
}
EOS
    end
  end

  #------------------------------------------------------------------------------
  describe 'Hash' do
    before do
      @hash = { 1 => { sym: { 'str' => { [1, 2, 3] => { { k: :v } => Hash } } } } }
    end

    it 'empty hash' do
      expect({}.ai).to eq('{}')
    end

    it 'plain multiline' do
      expect(@hash.ai(plain: true)).to eq <<-EOS.strip
{
    1 => {
        :sym => {
            "str" => {
                [ 1, 2, 3 ] => {
                    { :k => :v } => Hash < Object
                }
            }
        }
    }
}
EOS
    end

    it 'new hash syntax' do
      expect(@hash.ai(plain: true, ruby19_syntax: true)).to eq <<-EOS.strip
{
    1 => {
        sym: {
            "str" => {
                [ 1, 2, 3 ] => {
                    { k: :v } => Hash < Object
                }
            }
        }
    }
}
EOS
    end

    it 'plain multiline indented' do
      expect(@hash.ai(plain: true, indent: 1)).to eq <<-EOS.strip
{
 1 => {
  :sym => {
   "str" => {
    [ 1, 2, 3 ] => {
     { :k => :v } => Hash < Object
    }
   }
  }
 }
}
EOS
    end

    it 'plain single line' do
      expect(@hash.ai(plain: true, multiline: false)).to eq('{ 1 => { :sym => { "str" => { [ 1, 2, 3 ] => { { :k => :v } => Hash < Object } } } } }')
    end

    it 'colored multiline (default)' do
      expect(@hash.ai).to eq <<-EOS.strip
{
    1\e[0;37m => \e[0m{
        :sym\e[0;37m => \e[0m{
            \"str\"\e[0;37m => \e[0m{
                [ 1, 2, 3 ]\e[0;37m => \e[0m{
                    { :k => :v }\e[0;37m => \e[0m\e[1;33mHash < Object\e[0m
                }
            }
        }
    }
}
EOS
    end

    it 'colored with new hash syntax' do
      expect(@hash.ai(ruby19_syntax: true)).to eq <<-EOS.strip
{
    1\e[0;37m => \e[0m{
        sym\e[0;37m: \e[0m{
            \"str\"\e[0;37m => \e[0m{
                [ 1, 2, 3 ]\e[0;37m => \e[0m{
                    { k: :v }\e[0;37m => \e[0m\e[1;33mHash < Object\e[0m
                }
            }
        }
    }
}
EOS
    end

    it 'colored multiline indented' do
      expect(@hash.ai(indent: 2)).to eq <<-EOS.strip
{
  1\e[0;37m => \e[0m{
    :sym\e[0;37m => \e[0m{
      \"str\"\e[0;37m => \e[0m{
        [ 1, 2, 3 ]\e[0;37m => \e[0m{
          { :k => :v }\e[0;37m => \e[0m\e[1;33mHash < Object\e[0m
        }
      }
    }
  }
}
EOS
    end

    it 'colored single line' do
      expect(@hash.ai(multiline: false)).to eq("{ 1\e[0;37m => \e[0m{ :sym\e[0;37m => \e[0m{ \"str\"\e[0;37m => \e[0m{ [ 1, 2, 3 ]\e[0;37m => \e[0m{ { :k => :v }\e[0;37m => \e[0m\e[1;33mHash < Object\e[0m } } } } }")
    end

  end

  #------------------------------------------------------------------------------
  describe 'Nested Hash' do
    before do
      @hash = {}
      @hash[:a] = @hash
    end

    it 'plain multiline' do
      expect(@hash.ai(plain: true)).to eq <<-EOS.strip
{
    :a => {...}
}
EOS
    end

    it 'plain single line' do
      expect(@hash.ai(plain: true, multiline: false)).to eq('{ :a => {...} }')
    end
  end

  #------------------------------------------------------------------------------
  describe 'Hash with several keys' do
    before do
      @hash = { 'b' => 'b', :a => 'a', :z => 'z', 'alpha' => 'alpha' }
    end

    it 'plain multiline' do
      out = @hash.ai(plain: true)
      if RUBY_VERSION.to_f < 1.9 # Order of @hash keys is not guaranteed.
        expect(out).to match(/^\{[^\}]+\}/m)
        expect(out).to match(/        "b" => "b",?/)
        expect(out).to match(/         :a => "a",?/)
        expect(out).to match(/         :z => "z",?/)
        expect(out).to match(/    "alpha" => "alpha",?$/)
      else
        expect(out).to eq <<-EOS.strip
{
        "b" => "b",
         :a => "a",
         :z => "z",
    "alpha" => "alpha"
}
EOS
      end
    end

    it 'plain multiline with sorted keys' do
      expect(@hash.ai(plain: true, sort_keys: true)).to eq <<-EOS.strip
{
         :a => "a",
    "alpha" => "alpha",
        "b" => "b",
         :z => "z"
}
EOS
    end

  end

  #------------------------------------------------------------------------------
  describe 'Negative options[:indent]' do
    #
    # With Ruby < 1.9 the order of hash keys is not defined so we can't
    # reliably compare the output string.
    #
    it 'hash keys must be left aligned' do
      hash = { [0, 0, 255] => :yellow, :red => 'rgb(255, 0, 0)', 'magenta' => 'rgb(255, 0, 255)' }
      out = hash.ai(plain: true, indent: -4, sort_keys: true)
      expect(out).to eq <<-EOS.strip
{
    [ 0, 0, 255 ] => :yellow,
    "magenta"     => "rgb(255, 0, 255)",
    :red          => "rgb(255, 0, 0)"
}
EOS
    end

    it 'nested hash keys should be indented (array of hashes)' do
      arr = [{ a: 1, bb: 22, ccc: 333 }, { 1 => :a, 22 => :bb, 333 => :ccc }]
      out = arr.ai(plain: true, indent: -4, sort_keys: true)
      expect(out).to eq <<-EOS.strip
[
    [0] {
        :a   => 1,
        :bb  => 22,
        :ccc => 333
    },
    [1] {
        1   => :a,
        22  => :bb,
        333 => :ccc
    }
]
EOS
    end

    it 'nested hash keys should be indented (hash of hashes)' do
      arr = { first: { a: 1, bb: 22, ccc: 333 }, second: { 1 => :a, 22 => :bb, 333 => :ccc } }
      out = arr.ai(plain: true, indent: -4, sort_keys: true)
      expect(out).to eq <<-EOS.strip
{
    :first  => {
        :a   => 1,
        :bb  => 22,
        :ccc => 333
    },
    :second => {
        1   => :a,
        22  => :bb,
        333 => :ccc
    }
}
EOS
    end
  end

  #------------------------------------------------------------------------------
  describe 'Inherited from standard Ruby classes' do
    after do
      Object.instance_eval { remove_const :My } if defined?(My)
    end

    it 'inherited from Hash should be displayed as Hash' do
      class My < Hash; end

      my = My[{ 1 => { sym: { 'str' => { [1, 2, 3] => { { k: :v } => Hash } } } } }]
      expect(my.ai(plain: true)).to eq <<-EOS.strip
{
    1 => {
        :sym => {
            "str" => {
                [ 1, 2, 3 ] => {
                    { :k => :v } => Hash < Object
                }
            }
        }
    }
}
EOS
    end

  end
end
