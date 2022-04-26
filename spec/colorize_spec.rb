require 'spec_helper'

RSpec.describe AwesomePrint::Colorize do
  [:gray, :red, :green, :yellow, :blue, :purple, :cyan, :white].each_with_index do |color, i|
    it "should have #{color} color" do
      expect(AwesomePrint::Colorize.public_send(color, color.to_s)).to eq("\e[1;#{30 + i}m#{color}\e[0m")
    end

    it "should have #{color}ish color" do
      expect(AwesomePrint::Colorize.public_send(:"#{color}ish", color.to_s)).to eq("\e[0;#{30 + i}m#{color}\e[0m")
    end
  end

  it 'should have black and pale colors' do
    expect(AwesomePrint::Colorize.public_send(:black, 'black')).to eq(AwesomePrint::Colorize.public_send(:grayish, 'black'))
    expect(AwesomePrint::Colorize.public_send(:pale, 'pale')).to eq(AwesomePrint::Colorize.public_send(:whiteish, 'pale'))
    expect(AwesomePrint::Colorize.public_send(:pale, 'pale')).to eq("\e[0;37mpale\e[0m")
    expect(AwesomePrint::Colorize.public_send(:whiteish, 'whiteish')).to eq("\e[0;37mwhiteish\e[0m")
  end
end
