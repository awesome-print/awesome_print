require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

begin
  require 'awesome_print/ext/active_record'
  require File.expand_path(File.dirname(__FILE__) + '/../active_record_helper')

  if is_usable_activerecord?

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
          expect(out.gsub(/0x([a-f\d]+)/, "0x01234567")).to eq(str)
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
          expect(out.gsub(/0x([a-f\d]+)/, "0x01234567")).to eq(str)
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

          if activerecord_version >= "4.1"
            str = <<-EOS.strip
#<User:0x01234567
    @_start_transaction_state = {},
    @aggregation_cache = {},
    @attributes_cache = {},
    @column_types = {
             "admin" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
            attr_accessor :coder = nil,
            attr_accessor :primary = false,
            attr_reader :default = nil,
            attr_reader :default_function = nil,
            attr_reader :limit = nil,
            attr_reader :name = "admin",
            attr_reader :null = true,
            attr_reader :precision = nil,
            attr_reader :scale = nil,
            attr_reader :sql_type = "boolean",
            attr_reader :type = :boolean
        >,
        "created_at" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
            attr_accessor :coder = nil,
            attr_accessor :primary = false,
            attr_reader :default = nil,
            attr_reader :default_function = nil,
            attr_reader :limit = nil,
            attr_reader :name = "created_at",
            attr_reader :null = true,
            attr_reader :precision = nil,
            attr_reader :scale = nil,
            attr_reader :sql_type = "datetime",
            attr_reader :type = :datetime
        >,
                "id" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
            attr_accessor :coder = nil,
            attr_accessor :primary = true,
            attr_reader :default = nil,
            attr_reader :default_function = nil,
            attr_reader :limit = nil,
            attr_reader :name = "id",
            attr_reader :null = false,
            attr_reader :precision = nil,
            attr_reader :scale = nil,
            attr_reader :sql_type = "INTEGER",
            attr_reader :type = :integer
        >,
              "name" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
            attr_accessor :coder = nil,
            attr_accessor :primary = false,
            attr_reader :default = nil,
            attr_reader :default_function = nil,
            attr_reader :limit = 255,
            attr_reader :name = "name",
            attr_reader :null = true,
            attr_reader :precision = nil,
            attr_reader :scale = nil,
            attr_reader :sql_type = "varchar(255)",
            attr_reader :type = :string
        >,
              "rank" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
            attr_accessor :coder = nil,
            attr_accessor :primary = false,
            attr_reader :default = nil,
            attr_reader :default_function = nil,
            attr_reader :limit = nil,
            attr_reader :name = "rank",
            attr_reader :null = true,
            attr_reader :precision = nil,
            attr_reader :scale = nil,
            attr_reader :sql_type = "integer",
            attr_reader :type = :integer
        >
    },
    @column_types_override = nil,
    @destroyed = false,
    @marked_for_destruction = false,
    @new_record = true,
    @readonly = false,
    @reflects_state = [
        [0] false
    ],
    @transaction_state = nil,
    @txn = nil,
    attr_accessor :attributes = {
             "admin" => false,
        "created_at" => "1992-10-10 12:30:00",
                "id" => nil,
              "name" => "Diana",
              "rank" => 1
    },
    attr_accessor :destroyed_by_association = nil,
    attr_reader :association_cache = {},
    attr_reader :changed_attributes = {
             "admin" => nil,
        "created_at" => nil,
              "name" => nil,
              "rank" => nil
    }
>
EOS

          # ActiveRecord 3.1 and on.
          #--------------------------------------------------------------------------
          elsif activerecord_version >= "3.1"
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
          elsif activerecord_version.start_with?('3.0')
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
          elsif activerecord_version.start_with?('2.')
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
          expect(out.gsub(/0x([a-f\d]+)/, "0x01234567")).to eq(str)
        end

        it "display multiple records" do
          out = @ap.send(:awesome, [ @diana, @laura ])

          if activerecord_version >= "4.1"
            str = <<-EOS.strip
[
    [0] #<User:0x01234567
        @_start_transaction_state = {},
        @aggregation_cache = {},
        @attributes_cache = {},
        @column_types = {
                 "admin" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = false,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = nil,
                attr_reader :name = "admin",
                attr_reader :null = true,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "boolean",
                attr_reader :type = :boolean
            >,
            "created_at" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = false,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = nil,
                attr_reader :name = "created_at",
                attr_reader :null = true,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "datetime",
                attr_reader :type = :datetime
            >,
                    "id" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = true,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = nil,
                attr_reader :name = "id",
                attr_reader :null = false,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "INTEGER",
                attr_reader :type = :integer
            >,
                  "name" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = false,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = 255,
                attr_reader :name = "name",
                attr_reader :null = true,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "varchar(255)",
                attr_reader :type = :string
            >,
                  "rank" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = false,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = nil,
                attr_reader :name = "rank",
                attr_reader :null = true,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "integer",
                attr_reader :type = :integer
            >
        },
        @column_types_override = nil,
        @destroyed = false,
        @marked_for_destruction = false,
        @new_record = true,
        @readonly = false,
        @reflects_state = [
            [0] false
        ],
        @transaction_state = nil,
        @txn = nil,
        attr_accessor :attributes = {
                 "admin" => false,
            "created_at" => "1992-10-10 12:30:00",
                    "id" => nil,
                  "name" => "Diana",
                  "rank" => 1
        },
        attr_accessor :destroyed_by_association = nil,
        attr_reader :association_cache = {},
        attr_reader :changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        }
    >,
    [1] #<User:0x01234567
        @_start_transaction_state = {},
        @aggregation_cache = {},
        @attributes_cache = {},
        @column_types = {
                 "admin" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = false,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = nil,
                attr_reader :name = "admin",
                attr_reader :null = true,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "boolean",
                attr_reader :type = :boolean
            >,
            "created_at" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = false,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = nil,
                attr_reader :name = "created_at",
                attr_reader :null = true,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "datetime",
                attr_reader :type = :datetime
            >,
                    "id" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = true,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = nil,
                attr_reader :name = "id",
                attr_reader :null = false,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "INTEGER",
                attr_reader :type = :integer
            >,
                  "name" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = false,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = 255,
                attr_reader :name = "name",
                attr_reader :null = true,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "varchar(255)",
                attr_reader :type = :string
            >,
                  "rank" => #<ActiveRecord::ConnectionAdapters::SQLite3Column:0x01234567
                attr_accessor :coder = nil,
                attr_accessor :primary = false,
                attr_reader :default = nil,
                attr_reader :default_function = nil,
                attr_reader :limit = nil,
                attr_reader :name = "rank",
                attr_reader :null = true,
                attr_reader :precision = nil,
                attr_reader :scale = nil,
                attr_reader :sql_type = "integer",
                attr_reader :type = :integer
            >
        },
        @column_types_override = nil,
        @destroyed = false,
        @marked_for_destruction = false,
        @new_record = true,
        @readonly = false,
        @reflects_state = [
            [0] false
        ],
        @transaction_state = nil,
        @txn = nil,
        attr_accessor :attributes = {
                 "admin" => true,
            "created_at" => "2003-05-26 14:15:00",
                    "id" => nil,
                  "name" => "Laura",
                  "rank" => 2
        },
        attr_accessor :destroyed_by_association = nil,
        attr_reader :association_cache = {},
        attr_reader :changed_attributes = {
                 "admin" => nil,
            "created_at" => nil,
                  "name" => nil,
                  "rank" => nil
        }
    >
]
EOS
          elsif ActiveRecord::VERSION::STRING >= "3.1"
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
          expect(out.gsub(/0x([a-f\d]+)/, "0x01234567")).to eq(str)
        end
      end

      #------------------------------------------------------------------------------
      describe "ActiveRecord class" do
        before do
          @ap = AwesomePrint::Inspector.new(:plain => true)
        end

        it "should print the class" do
          expect(@ap.send(:awesome, User)).to eq <<-EOS.strip
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
          out = @ap.send(:awesome, SubUser)
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

        it "should print ActiveRecord::Base objects (ex. ancestors)" do
          expect { @ap.send(:awesome, User.ancestors) }.not_to raise_error
        end
      end

      #------------------------------------------------------------------------------
      describe "ActiveRecord methods formatting" do
        before do
          @ap = AwesomePrint::Inspector.new(:plain => true)
        end

        it "should format class methods properly" do
          # spec 1
          out = @ap.send(:awesome, User.methods.grep(/first/))

          if ActiveRecord::VERSION::STRING >= "3.2"
            if RUBY_VERSION >= "1.9"
              expect(out).to match(/\sfirst\(\*args,\s&block\)\s+Class \(ActiveRecord::Querying\)/)
            else
              expect(out).to match(/\sfirst\(\*arg1\)\s+Class \(ActiveRecord::Querying\)/)
            end
          else
            expect(out).to match(/\sfirst\(\*arg.*?\)\s+User \(ActiveRecord::Base\)/)
          end

          # spec 2
          out = @ap.send(:awesome, User.methods.grep(/primary_key/))
          if activerecord_version >= "4.1"
            expect(out).to match(/\sprimary_key\(.*?\)\s+Class \(ActiveRecord::AttributeMethods::PrimaryKey::ClassMethods\)/)
          else
            expect(out).to match(/\sprimary_key\(.*?\)\s+User/)
          end

          # spec 3
          out = @ap.send(:awesome, User.methods.grep(/validate/))

          if ActiveRecord::VERSION::MAJOR < 3
            expect(out).to match(/\svalidate\(\*arg.*?\)\s+User \(ActiveRecord::Base\)/)
          else
            expect(out).to match(/\svalidate\(\*arg.*?\)\s+Class \(ActiveModel::Validations::ClassMethods\)/)
          end

        end
      end
    end
  end
rescue LoadError => error
  puts "Skipping ActiveRecord specs: #{error}"
end
