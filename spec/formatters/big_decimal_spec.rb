require_relative '../spec_helper'
require 'bigdecimal'
require 'rational'

RSpec.describe 'AwesomePrint' do
  #------------------------------------------------------------------------------
  describe 'BigDecimal and Rational' do
    it 'should present BigDecimal object with arbitrary precision' do
      big = BigDecimal('201020102010201020102010201020102010.4')
      expect(big.ai(plain: true)).to eq('201020102010201020102010201020102010.4')
    end

    it 'should present Rational object with arbitrary precision' do
      rat = Rational(201020102010201020102010201020102010, 2)
      out = rat.ai(plain: true)
      #
      # Ruby 1.9 slightly changed the format of Rational#to_s, see
      # http://techtime.getharvest.com/blog/harvest-is-now-on-ruby-1-dot-9-3 and
      # http://www.ruby-forum.com/topic/189397
      #
      if RUBY_VERSION < '1.9'
        expect(out).to eq('100510051005100510051005100510051005')
      else
        expect(out).to eq('100510051005100510051005100510051005/1')
      end
    end
  end
end
