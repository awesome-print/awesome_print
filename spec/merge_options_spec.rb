require_relative 'spec_helper'

RSpec.describe 'AwesomePrint' do
  describe 'Utility methods' do
    it 'should merge options' do
      ap = AwesomePrint::Inspector.new
      ap.send(:merge_options!, { color: { array: :black }, indent: 0 })
      options = ap.instance_variable_get('@options')
      expect(options[:color][:array]).to eq(:black)
      expect(options[:indent]).to eq(0)
    end
  end
end
