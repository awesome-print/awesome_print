require_relative '../spec_helper'
require 'set'

RSpec.describe 'AwesomePrint' do
  describe 'Set' do
    before do
      @arr = [1, :two, 'three']
      @set = Set.new(@arr)
    end

    it 'empty set' do
      expect(Set.new.ai).to eq([].ai)
    end

    if RUBY_VERSION > '1.9'
      it 'plain multiline' do
        expect(@set.ai(plain: true)).to eq(@arr.ai(plain: true))
      end

      it 'plain multiline indented' do
        expect(@set.ai(plain: true, indent: 1)).to eq(@arr.ai(plain: true, indent: 1))
      end

      it 'plain single line' do
        expect(@set.ai(plain: true, multiline: false)).to eq(@arr.ai(plain: true, multiline: false))
      end

      it 'colored multiline (default)' do
        expect(@set.ai).to eq(@arr.ai)
      end
    else # Prior to Ruby 1.9 the order of set values is unpredicatble.
      it 'plain multiline' do
        expect(@set.sort_by { |x| x.to_s }.ai(plain: true)).to eq(@arr.sort_by { |x| x.to_s }.ai(plain: true))
      end

      it 'plain multiline indented' do
        expect(@set.sort_by { |x| x.to_s }.ai(plain: true, indent: 1)).to eq(@arr.sort_by { |x| x.to_s }.ai(plain: true, indent: 1))
      end

      it 'plain single line' do
        expect(@set.sort_by { |x| x.to_s }.ai(plain: true, multiline: false)).to eq(@arr.sort_by { |x| x.to_s }.ai(plain: true, multiline: false))
      end

      it 'colored multiline (default)' do
        expect(@set.sort_by { |x| x.to_s }.ai).to eq(@arr.sort_by { |x| x.to_s }.ai)
      end
    end
  end
end
