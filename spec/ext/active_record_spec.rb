require 'spec_helper'
require 'active_record_helper'

RSpec.describe 'AwesomePrint/ActiveRecord', skip: -> { !ExtVerifier.has_rails? }.call do
  describe 'ActiveRecord instance, attributes only (default)' do
    before do
      ActiveRecord::Base.default_timezone = :utc
      @diana = User.new(name: 'Diana', rank: 1, admin: false, created_at: '1992-10-10 12:30:00')
      @laura = User.new(name: 'Laura', rank: 2, admin: true,  created_at: '2003-05-26 14:15:00')
      @ap = AwesomePrint::Inspector.new(plain: true, sort_keys: true)
    end

    it 'display single record' do
      out = @ap.awesome(@diana)
      str = <<-EOS.strip
#<User:placeholder_id> {
         :admin => false,
    :created_at => ?,
            :id => nil,
          :name => "Diana",
          :rank => 1
}
      EOS

			expect(RUBY_VERSION).to be >= '2.5'

      str.sub!('?', '1992-10-10 12:30:00 UTC')

      expect(out).to be_similar_to(str)
    end

    it 'display multiple records' do
      out = @ap.awesome([@diana, @laura])
      str = <<-EOS.strip
[
    [0] #<User:placeholder_id> {
             :admin => false,
        :created_at => ??,
                :id => nil,
              :name => "Diana",
              :rank => 1
    },
    [1] #<User:placeholder_id> {
             :admin => true,
        :created_at => ?!,
                :id => nil,
              :name => "Laura",
              :rank => 2
    }
]
      EOS

      str.sub!('??', '1992-10-10 12:30:00 UTC')
      str.sub!('?!', '2003-05-26 14:15:00 UTC')

      expect(out).to be_similar_to(str)
    end

    it 'display multiple records on a relation' do
      @diana.save
      @laura.save
      out = @ap.awesome(User.all)
      str = <<-EOS.strip
[
    [0] #<User:placeholder_id> {
             :admin => false,
        :created_at => ??,
                :id => 1,
              :name => "Diana",
              :rank => 1
    },
    [1] #<User:placeholder_id> {
             :admin => true,
        :created_at => ?!,
                :id => 2,
              :name => "Laura",
              :rank => 2
    }
]
      EOS

      str.sub!('??', '1992-10-10 12:30:00 UTC')
      str.sub!('?!', '2003-05-26 14:15:00 UTC')

      expect(out).to be_similar_to(str)
    end
  end

  describe 'Linked records (joins)' do
    before do
      @ap = AwesomePrint::Inspector.new(plain: true)
    end

    it 'should show the entire record' do
      e = Email.create(email_address: 'foo@bar.com')
      u = User.last
      u.emails << e
      email_record = User.joins(:emails).select('users.id, emails.email_address').last
      out = @ap.awesome(email_record)
      raw_object_string = <<-EOS.strip
#<User:placeholder_id> {
               "id" => #{u.id},
    "email_address" => "#{e.email_address}"
}
EOS
      expect(out).to be_similar_to(raw_object_string)
    end
  end

  #------------------------------------------------------------------------------
  describe 'ActiveRecord instance (raw)' do
    before do
      ActiveRecord::Base.default_timezone = :utc
      @diana = User.new(name: 'Diana', rank: 1, admin: false, created_at: '1992-10-10 12:30:00')
      @laura = User.new(name: 'Laura', rank: 2, admin: true,  created_at: '2003-05-26 14:15:00')
      @ap = AwesomePrint::Inspector.new(plain: true, sort_keys: true, raw: true)
    end

    it 'display single record' do
      out = @ap.awesome(@diana)

      raw_object_string =
        if activerecord_6_1?
          ActiveRecordData.raw_6_1_diana
        elsif activerecord_6_0?
          ActiveRecordData.raw_6_0_diana
        elsif activerecord_5_2?
          ActiveRecordData.raw_5_2_diana
        elsif activerecord_5_1?
          ActiveRecordData.raw_5_1_diana
        elsif activerecord_5_0?
          ActiveRecordData.raw_5_0_diana
        elsif activerecord_4_2?
          ActiveRecordData.raw_4_2_diana
        elsif activerecord_4_1?
          ActiveRecordData.raw_4_1_diana
        elsif activerecord_4_0?
          ActiveRecordData.raw_4_0_diana
        elsif activerecord_3_2?
          ActiveRecordData.raw_3_2_diana
        end
      raw_object_string.sub!('?', '1992-10-10 12:30:00')
      expect(out).to be_similar_to(raw_object_string)
    end

    it 'display multiple records' do
      out = @ap.awesome([@diana, @laura])

      raw_object_string =
        if activerecord_6_1?
          ActiveRecordData.raw_6_1_multi
        elsif activerecord_6_0?
          ActiveRecordData.raw_6_0_multi
        elsif activerecord_5_2?
          ActiveRecordData.raw_5_2_multi
        elsif activerecord_5_1?
          ActiveRecordData.raw_5_1_multi
        elsif activerecord_5_0?
          ActiveRecordData.raw_5_0_multi
        elsif activerecord_4_2?
          ActiveRecordData.raw_4_2_multi
        elsif activerecord_4_1?
          ActiveRecordData.raw_4_1_multi
        elsif activerecord_4_0?
          ActiveRecordData.raw_4_0_multi
        elsif activerecord_3_2?
          ActiveRecordData.raw_3_2_multi
        end
      raw_object_string.sub!('?', '1992-10-10 12:30:00')
      raw_object_string.sub!('?', '2003-05-26 14:15:00')
      expect(out).to be_similar_to(raw_object_string)
    end
  end

  #------------------------------------------------------------------------------
  describe 'ActiveRecord class' do
    before do
      @ap = AwesomePrint::Inspector.new(plain: true)
    end

    it 'should print the class' do
      expect(@ap.awesome(User)).to eq <<-EOS.strip
class User < ActiveRecord::Base {
            :id => :integer,
          :name => :string,
          :rank => :integer,
         :admin => :boolean,
    :created_at => :datetime
}
      EOS
    end

    it 'should print the class for non-direct subclasses of ActiveRecord::Base' do
      out = @ap.awesome(SubUser)
      expect(out).to eq <<-EOS.strip
class SubUser < User {
            :id => :integer,
          :name => :string,
          :rank => :integer,
         :admin => :boolean,
    :created_at => :datetime
}
      EOS
    end

    it 'should print ActiveRecord::Base objects (ex. ancestors)' do
      expect { @ap.awesome(User.ancestors) }.not_to raise_error
    end
  end

  #------------------------------------------------------------------------------
  describe 'ActiveRecord methods formatting' do
    before do
      @ap = AwesomePrint::Inspector.new(plain: true)
    end

    it 'should format class methods properly' do
      # spec 1
      out = @ap.awesome(User.methods.grep(/first/))

      if RUBY_VERSION >= '3.0.0'
        expect(out).to match(/\sfirst\(\*\*,\s&&\)/)
      elsif RUBY_VERSION >= '2.7.0'
        if ActiveRecord::VERSION::STRING >= '3.2'
          expect(out).to match(/\sfirst\(\*\*,\s&&\)\s+User/)
        else
          expect(out).to match(/\sfirst\(\*\*,\s&&\)\s+User \(ActiveRecord::Base\)/)
        end
      else
        if ActiveRecord::VERSION::STRING >= '3.2'
          expect(out).to match(/\sfirst\(\*arg.*?\)\s+User/)
        else
          expect(out).to match(/\sfirst\(\*arg.*?\)\s+User \(ActiveRecord::Base\)/)
        end
      end

      # spec 2
      out = @ap.awesome(User.methods.grep(/primary_key/))
      if RUBY_VERSION >= '3.0.0'
        expect(out).to match(/\sprimary_key\(.*?\)/)
      else
        expect(out).to match(/\sprimary_key\(.*?\)\s+User/)
      end

      # spec 3
      out = @ap.awesome(User.methods.grep(/validate/))
      if ActiveRecord::VERSION::MAJOR < 3
        expect(out).to match(/\svalidate\(\*arg.*?\)\s+User \(ActiveRecord::Base\)/)
      else
        if RUBY_VERSION >= '3.0.0'
          expect(out).to match(/\svalidate\(\*arg.*?\)/)
        else
          expect(out).to match(/\svalidate\(\*arg.*?\)\s+User/)
        end
      end

    end
  end
end

