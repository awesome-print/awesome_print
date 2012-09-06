require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require 'active_record'
  require 'awesome_print/ext/active_record'

  if defined?(ActiveRecord::VERSION::MAJOR) && ActiveRecord::VERSION::MAJOR >= 2

    # Create tableless ActiveRecord model.
    #------------------------------------------------------------------------------
    class User < ActiveRecord::Base
      def self.columns()
        @columns ||= []
      end

      # Tableless model support for ActiveRecord 3.1 mess.
      if self.respond_to?(:column_defaults)
        def self.primary_key
          :id
        end

        def self.column_defaults
          @column_defaults ||= Hash[columns.map { |column| [column.name, nil] }]
        end

        def self.columns_hash
          @columns_hash ||= Hash[columns.map { |column| [column.name, column] }]
        end
      end

      def self.column(name, sql_type = nil, default = nil, null = true)
        columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
      end

      column :id, :integer
      column :name, :string
      column :rank, :integer
      column :admin, :boolean
      column :created_at, :datetime

      def self.table_exists?
        true
      end
    end

    class SubUser < User
      def self.columns
        User.columns
      end
    end

    describe "AwesomePrint/ActiveRecord" do
      before do
        stub_dotfile!
      end

      #------------------------------------------------------------------------------
      describe "ActiveRecord instance, attributes only (default)" do
        before do
          ActiveRecord::Base.default_timezone = :utc
          @diana = User.new(:name => "Diana", :rank => 1, :admin => false, :created_at => "1992-10-10 12:30:00")
          @laura = User.new(:name => "Laura", :rank => 2, :admin => true,  :created_at => "2003-05-26 14:15:00")
          @ap = AwesomePrint::Inspector.new(:plain => true, :sort_keys => true)
        end

        it "display single record" do
          out = @ap.send(:awesome, @diana)
          str = <<-EOS.strip
#<User:0x01234567> {
         :admin => false,
    :created_at => ?,
            :id => nil,
          :name => "Diana",
          :rank => 1
}
EOS
          if RUBY_VERSION < '1.9'
            str.sub!('?', 'Sat Oct 10 12:30:00 UTC 1992')
          else
            str.sub!('?', '1992-10-10 12:30:00 UTC')
          end
          out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
        end

        it "display multiple records" do
          out = @ap.send(:awesome, [ @diana, @laura ])
          str = <<-EOS.strip
[
    [0] #<User:0x01234567> {
             :admin => false,
        :created_at => ??,
                :id => nil,
              :name => "Diana",
              :rank => 1
    },
    [1] #<User:0x01234567> {
             :admin => true,
        :created_at => ?!,
                :id => nil,
              :name => "Laura",
              :rank => 2
    }
]
EOS
          if RUBY_VERSION < '1.9'
            str.sub!('??', 'Sat Oct 10 12:30:00 UTC 1992')
            str.sub!('?!', 'Mon May 26 14:15:00 UTC 2003')
          else
            str.sub!('??', '1992-10-10 12:30:00 UTC')
            str.sub!('?!', '2003-05-26 14:15:00 UTC')
          end
          out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
        end
      end

      #------------------------------------------------------------------------------
      describe "ActiveRecord instance (raw)" do
        before do
          ActiveRecord::Base.default_timezone = :utc
          @diana = User.new(:name => "Diana", :rank => 1, :admin => false, :created_at => "1992-10-10 12:30:00")
          @laura = User.new(:name => "Laura", :rank => 2, :admin => true,  :created_at => "2003-05-26 14:15:00")
          @ap = AwesomePrint::Inspector.new(:plain => true, :sort_keys => true, :raw => true)
        end

        it "display single record" do
          out = @ap.send(:awesome, @diana)

          # ActiveRecord 3.1 and on.
          #--------------------------------------------------------------------------
          if ActiveRecord::VERSION::STRING >= "3.1"
            str = <<-EOS.strip
#<User:0x01234567
    @aggregation_cache = {},
    @attributes_cache = {},
    @destroyed = false,
    @marked_for_destruction = false,
    @new_record = true,
    @previously_changed = {},
    @readonly = false,
    @relation = nil,
    attr_accessor :attributes = {
             "admin" => false,
        "created_at" => "1992-10-10 12:30:00",
                "id" => nil,
              "name" => "Diana",
              "rank" => 1
    },
    attr_reader :association_cache = {},
    attr_reader :changed_attributes = {
             "admin" => nil,
        "created_at" => nil,
              "name" => nil,
              "rank" => nil
    },
    attr_reader :mass_assignment_options = nil
>
EOS
          # ActiveRecord 3.0.x
          #--------------------------------------------------------------------------
          elsif ActiveRecord::VERSION::STRING.start_with?('3.0')
            str = <<-EOS.strip
#<User:0x01234567
    @attributes_cache = {},
    @destroyed = false,
    @marked_for_destruction = false,
    @new_record = true,
    @previously_changed = {},
    @readonly = false,
    attr_accessor :attributes = {
             "admin" => false,
        "created_at" => "?",
              "name" => "Diana",
              "rank" => 1
    },
    attr_reader :changed_attributes = {
             "admin" => nil,
        "created_at" => nil,
              "name" => nil,
              "rank" => nil
    }
>
EOS
          # ActiveRecord 2.x
          #--------------------------------------------------------------------------
          elsif ActiveRecord::VERSION::STRING.start_with?('2.')
            str = <<-EOS.strip
#<User:0x01234567
    @attributes_cache = {},
    @changed_attributes = {
             "admin" => nil,
        "created_at" => nil,
              "name" => nil,
              "rank" => nil
    },
    @new_record = true,
    attr_accessor :attributes = {
             "admin" => false,
        "created_at" => "1992-10-10 12:30:00",
              "name" => "Diana",
              "rank" => 1
    }
>
EOS
          end
          str.sub!('?', '1992-10-10 12:30:00')
          out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
        end

        it "display multiple records" do
          out = @ap.send(:awesome, [ @diana, @laura ])

          # ActiveRecord 3.1 and on.
          #--------------------------------------------------------------------------
          if ActiveRecord::VERSION::STRING >= "3.1"
            str = <<-EOS.strip
[
    [0] #<User:0x01234567
        @aggregation_cache = {},
        @attributes_cache = {},
        @destroyed = false,
        @marked_for_destruction = false,
        @new_record = true,
        @previously_changed = {},
        @readonly = false,
        @relation = nil,
        attr_accessor :attributes = {
                 "admin" => false,
            "created_at" => "1992-10-10 12:30:00",
                    "id" => nil,
                  "name" => "Diana",
                  "rank" => 1
        },
        attr_reader :association_cache = {},
        attr_reader :changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        },
        attr_reader :mass_assignment_options = nil
    >,
    [1] #<User:0x01234567
        @aggregation_cache = {},
        @attributes_cache = {},
        @destroyed = false,
        @marked_for_destruction = false,
        @new_record = true,
        @previously_changed = {},
        @readonly = false,
        @relation = nil,
        attr_accessor :attributes = {
                 "admin" => true,
            "created_at" => "2003-05-26 14:15:00",
                    "id" => nil,
                  "name" => "Laura",
                  "rank" => 2
        },
        attr_reader :association_cache = {},
        attr_reader :changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        },
        attr_reader :mass_assignment_options = nil
    >
]
EOS
          # ActiveRecord 3.0.x
          #--------------------------------------------------------------------------
          elsif ActiveRecord::VERSION::STRING.start_with?('3.0')
            str = <<-EOS.strip
[
    [0] #<User:0x01234567
        @attributes_cache = {},
        @destroyed = false,
        @marked_for_destruction = false,
        @new_record = true,
        @previously_changed = {},
        @readonly = false,
        attr_accessor :attributes = {
                 "admin" => false,
            "created_at" => "?",
                  "name" => "Diana",
                  "rank" => 1
        },
        attr_reader :changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        }
    >,
    [1] #<User:0x01234567
        @attributes_cache = {},
        @destroyed = false,
        @marked_for_destruction = false,
        @new_record = true,
        @previously_changed = {},
        @readonly = false,
        attr_accessor :attributes = {
                 "admin" => true,
            "created_at" => "?",
                  "name" => "Laura",
                  "rank" => 2
        },
        attr_reader :changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        }
    >
]
EOS
          # ActiveRecord 2.0.x
          #--------------------------------------------------------------------------
          elsif ActiveRecord::VERSION::STRING.start_with?('2.')
            str = <<-EOS.strip
[
    [0] #<User:0x01234567
        @attributes_cache = {},
        @changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        },
        @new_record = true,
        attr_accessor :attributes = {
                 "admin" => false,
            "created_at" => "1992-10-10 12:30:00",
                  "name" => "Diana",
                  "rank" => 1
        }
    >,
    [1] #<User:0x01234567
        @attributes_cache = {},
        @changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        },
        @new_record = true,
        attr_accessor :attributes = {
                 "admin" => true,
            "created_at" => "2003-05-26 14:15:00",
                  "name" => "Laura",
                  "rank" => 2
        }
    >
]
EOS
          end
          str.sub!('?', '1992-10-10 12:30:00')
          str.sub!('?', '2003-05-26 14:15:00')
          out.gsub(/0x([a-f\d]+)/, "0x01234567").should == str
        end
      end

      #------------------------------------------------------------------------------
      describe "ActiveRecord class" do
        before do
          @ap = AwesomePrint::Inspector.new(:plain => true)
        end

        it "should print the class" do
          @ap.send(:awesome, User).should == <<-EOS.strip
class User < ActiveRecord::Base {
            :id => :integer,
          :name => :string,
          :rank => :integer,
         :admin => :boolean,
    :created_at => :datetime
}
EOS
        end

        it "should print the class for non-direct subclasses of ActiveRecord::Base" do
          @ap.send(:awesome, SubUser).should == <<-EOS.strip
class SubUser < User {
            :id => :integer,
          :name => :string,
          :rank => :integer,
         :admin => :boolean,
    :created_at => :datetime
}
EOS
        end

        it "should print ActiveRecord::Base objects (ex. ancestors)" do
          lambda { @ap.send(:awesome, User.ancestors) }.should_not raise_error
        end
      end

      #------------------------------------------------------------------------------
      describe "ActiveRecord methods formatting" do
        before do
          @ap = AwesomePrint::Inspector.new(:plain => true)
        end

        it "should format class methods properly" do
          out = @ap.send(:awesome, User.methods.grep(/first/))

          if ActiveRecord::VERSION::STRING >= "3.2"
            if RUBY_VERSION >= "1.9"
              out.should =~ /\sfirst\(\*args,\s&block\)\s+Class \(ActiveRecord::Querying\)/
            else
              out.should =~ /\sfirst\(\*arg1\)\s+Class \(ActiveRecord::Querying\)/
            end
          else
            out.should =~ /\sfirst\(\*arg.*?\)\s+User \(ActiveRecord::Base\)/
          end

          out = @ap.send(:awesome, User.methods.grep(/primary_key/))
          out.should =~ /\sprimary_key\(.*?\)\s+User/

          out = @ap.send(:awesome, User.methods.grep(/validate/))
          if ActiveRecord::VERSION::MAJOR < 3
            out.should =~ /\svalidate\(\*arg.*?\)\s+User \(ActiveRecord::Base\)/
          else
            out.should =~ /\svalidate\(\*arg.*?\)\s+Class \(ActiveModel::Validations::ClassMethods\)/
          end
        end
      end
    end
  end
rescue LoadError => error
  puts "Skipping ActiveRecord specs: #{error}"
end
