require 'spec_helper'

RSpec.describe 'String extensions' do
  [:gray, :red, :green, :yellow, :blue, :purple, :cyan, :white].each_with_index do |color, i|
    it "should have #{color} color" do
      expect(color.to_s.send(color)).to eq("\e[1;#{30 + i}m#{color}\e[0m")
    end

    it "should have #{color}ish color" do
      expect(color.to_s.send(:"#{color}ish")).to eq("\e[0;#{30 + i}m#{color}\e[0m")
    end
  end

  it 'should have black and pale colors' do
    expect('black'.send(:black)).to eq('black'.send(:grayish))
    expect('pale'.send(:pale)).to eq('pale'.send(:whiteish))
    expect('pale'.send(:pale)).to eq("\e[0;37mpale\e[0m")
    expect('whiteish'.send(:whiteish)).to eq("\e[0;37mwhiteish\e[0m")
  end
end
