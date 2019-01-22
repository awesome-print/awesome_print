require_relative '../spec_helper'

RSpec.describe 'AwesomePrint' do
  describe 'Array' do
    before do
      @arr = [1, :two, 'three', [nil, [true, false]]]
    end

    it 'empty array' do
      expect([].ai).to eq('[]')
    end

    it 'plain multiline' do
      expect(@arr.ai(plain: true)).to eq <<-EOS.strip
[
    [0] 1,
    [1] :two,
    [2] "three",
    [3] [
        [0] nil,
        [1] [
            [0] true,
            [1] false
        ]
    ]
]
EOS
      end

    it 'plain multiline without index' do
      expect(@arr.ai(plain: true, index: false)).to eq <<-EOS.strip
[
    1,
    :two,
    "three",
    [
        nil,
        [
            true,
            false
        ]
    ]
]
EOS
      end

    it 'plain multiline indented' do
      expect(@arr.ai(plain: true, indent: 2)).to eq <<-EOS.strip
[
  [0] 1,
  [1] :two,
  [2] "three",
  [3] [
    [0] nil,
    [1] [
      [0] true,
      [1] false
    ]
  ]
]
EOS
    end

    it 'plain multiline indented without index' do
      expect(@arr.ai(plain: true, indent: 2, index: false)).to eq <<-EOS.strip
[
  1,
  :two,
  "three",
  [
    nil,
    [
      true,
      false
    ]
  ]
]
EOS
    end

    it 'plain single line' do
      expect(@arr.ai(plain: true, multiline: false)).to eq('[ 1, :two, "three", [ nil, [ true, false ] ] ]')
    end

    it 'colored multiline (default)' do
      expect(@arr.ai).to eq <<-EOS.strip
[
    \e[1;37m[0] \e[0m\e[1;34m1\e[0m,
    \e[1;37m[1] \e[0m\e[0;36m:two\e[0m,
    \e[1;37m[2] \e[0m\e[0;33m\"three\"\e[0m,
    \e[1;37m[3] \e[0m[
        \e[1;37m[0] \e[0m\e[1;31mnil\e[0m,
        \e[1;37m[1] \e[0m[
            \e[1;37m[0] \e[0m\e[1;32mtrue\e[0m,
            \e[1;37m[1] \e[0m\e[1;31mfalse\e[0m
        ]
    ]
]
EOS
      end

    it 'colored multiline indented' do
      expect(@arr.ai(indent: 8)).to eq <<-EOS.strip
[
        \e[1;37m[0] \e[0m\e[1;34m1\e[0m,
        \e[1;37m[1] \e[0m\e[0;36m:two\e[0m,
        \e[1;37m[2] \e[0m\e[0;33m\"three\"\e[0m,
        \e[1;37m[3] \e[0m[
                \e[1;37m[0] \e[0m\e[1;31mnil\e[0m,
                \e[1;37m[1] \e[0m[
                        \e[1;37m[0] \e[0m\e[1;32mtrue\e[0m,
                        \e[1;37m[1] \e[0m\e[1;31mfalse\e[0m
                ]
        ]
]
EOS
    end

    it 'colored single line' do
      expect(@arr.ai(multiline: false)).to eq("[ \e[1;34m1\e[0m, \e[0;36m:two\e[0m, \e[0;33m\"three\"\e[0m, [ \e[1;31mnil\e[0m, [ \e[1;32mtrue\e[0m, \e[1;31mfalse\e[0m ] ] ]")
    end
  end

  #------------------------------------------------------------------------------
  describe 'Nested Array' do
    before do
      @arr = [1, 2]
      @arr << @arr
    end

    it 'plain multiline' do
      expect(@arr.ai(plain: true)).to eq <<-EOS.strip
[
    [0] 1,
    [1] 2,
    [2] [...]
]
EOS
    end

    it 'plain multiline without index' do
      expect(@arr.ai(plain: true, index: false)).to eq <<-EOS.strip
[
    1,
    2,
    [...]
]
EOS
    end

    it 'plain single line' do
      expect(@arr.ai(plain: true, multiline: false)).to eq('[ 1, 2, [...] ]')
    end
  end

  #------------------------------------------------------------------------------
  describe 'Limited Output Array' do
    before(:each) do
      @arr = (1..1000).to_a
    end

    it 'plain limited output large' do
      expect(@arr.ai(plain: true, limit: true)).to eq <<-EOS.strip
[
    [  0] 1,
    [  1] 2,
    [  2] 3,
    [  3] .. [996],
    [997] 998,
    [998] 999,
    [999] 1000
]
EOS
    end

    it 'plain limited output small' do
      @arr = @arr[0..3]
      expect(@arr.ai(plain: true, limit: true)).to eq <<-EOS.strip
[
    [0] 1,
    [1] 2,
    [2] 3,
    [3] 4
]
EOS
    end

    it 'plain limited output with 10 lines' do
      expect(@arr.ai(plain: true, limit: 10)).to eq <<-EOS.strip
[
    [  0] 1,
    [  1] 2,
    [  2] 3,
    [  3] 4,
    [  4] 5,
    [  5] .. [995],
    [996] 997,
    [997] 998,
    [998] 999,
    [999] 1000
]
EOS
    end

    it 'plain limited output with 11 lines' do
      expect(@arr.ai(plain: true, limit: 11)).to eq <<-EOS.strip
[
    [  0] 1,
    [  1] 2,
    [  2] 3,
    [  3] 4,
    [  4] 5,
    [  5] .. [994],
    [995] 996,
    [996] 997,
    [997] 998,
    [998] 999,
    [999] 1000
]
EOS
    end
  end

  #------------------------------------------------------------------------------
  describe 'Inherited from standard Ruby classes' do
    after do
      Object.instance_eval { remove_const :My } if defined?(My)
    end

    it 'inherited from Array should be displayed as Array' do
      class My < Array; end

      my = My.new([1, :two, 'three', [nil, [true, false]]])
      expect(my.ai(plain: true)).to eq <<-EOS.strip
[
    [0] 1,
    [1] :two,
    [2] "three",
    [3] [
        [0] nil,
        [1] [
            [0] true,
            [1] false
        ]
    ]
]
EOS
    end

  end
end
