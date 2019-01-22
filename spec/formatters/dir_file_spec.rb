require_relative '../spec_helper'

RSpec.describe 'AwesomePrint' do

  describe 'File' do
    it 'should display a file (plain)' do
      File.open(__FILE__, 'r') do |f|
        expect(f.ai(plain: true)).to eq("#{f.inspect}\n" << `ls -alF #{f.path}`.chop)
      end
    end
  end

  describe 'Dir' do
    it 'should display a direcory (plain)' do
      Dir.open(File.dirname(__FILE__)) do |d|
        expect(d.ai(plain: true)).to eq("#{d.inspect}\n" << `ls -alF #{d.path}`.chop)
      end
    end
  end

  describe 'Inherited from standard Ruby classes' do
    after do
      Object.instance_eval { remove_const :My } if defined?(My)
    end

    it 'inherited from File should be displayed as File' do
      class My < File; end

      my = File.new('/dev/null') rescue File.new('nul')
      expect(my.ai(plain: true)).to eq("#{my.inspect}\n" << `ls -alF #{my.path}`.chop)
    end

    it 'inherited from Dir should be displayed as Dir' do
      class My < Dir; end

      require 'tmpdir'
      my = My.new(Dir.tmpdir)

      expect(my.ai(plain: true)).to eq("#{my.inspect}\n" << `ls -alF #{my.path}`.chop)
    end

  end
end
