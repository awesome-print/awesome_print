require 'spec_helper'

RSpec.describe 'AwesomePrint' do
  describe 'custom default colors' do
    around do |example|
      original_defaults = AwesomePrint.defaults
      example.run
      AwesomePrint.defaults = original_defaults
    end

    it 'retains programmatically set defaults' do
      array = [1, 2, 3]
      red_array_indexes = "[\n    \e[1\;31m[0] \e[0m\e[1\;34m1\e[0m,\n    \e[1\;31m[1] \e[0m\e[1\;34m2\e[0m,\n    \e[1\;31m[2] \e[0m\e[1\;34m3\e[0m\n]"
      AwesomePrint.defaults = {color: {array: :red}}
      array.ai
      expect(array.ai).to eq(red_array_indexes)
    end
  end
end
