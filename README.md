## Awesome Print ##
Awesome Print is Ruby library that pretty prints Ruby objects in full color
exposing their internal structure with proper indentation. Rails ActiveRecord
objects and usage within Rails templates are supported via included mixins.

### Installation ###
    # Installing as Ruby gem
    $ gem install awesome_print

    # Installing as Rails plugin
    $ ruby script/plugin install http://github.com/michaeldv/awesome_print.git

    # Cloning the repository
    $ git clone git://github.com/michaeldv/awesome_print.git

### Usage ###

    require "awesome_print"
    ap object, options = {}

Default options:

    :multiline => true,           # Display in multiple lines.
    :plain     => false,          # Use colors.
    :indent    => 4,              # Indent using 4 spaces.
    :index     => true,           # Display array indices.
    :html      => false,          # Use ANSI color codes rather than HTML.
    :sorted_hash_keys => false,   # Do not sort hash keys.
    :color => {
      :array      => :white,
      :bignum     => :blue,
      :class      => :yellow,
      :date       => :greenish,
      :falseclass => :red,
      :fixnum     => :blue,
      :float      => :blue,
      :hash       => :gray,
      :nilclass   => :red,
      :string     => :yellowish,
      :symbol     => :cyanish,
      :time       => :greenish,
      :trueclass  => :green
    }

Supported color names:

    :gray, :red, :green, :yellow, :blue, :purple, :cyan, :white
    :black, :redish, :greenish, :yellowish, :blueish, :purpleish, :cyanish, :pale

### Examples ###
    $ cat > 1.rb
    require "awesome_print"
    data = [ false, 42, %w(forty two), { :now => Time.now, :class => Time.now.class, :distance => 42e42 } ]
    ap data
    ^D
    $ ruby 1.rb
    [
        [0] false,
        [1] 42,
        [2] [
            [0] "forty",
            [1] "two"
        ],
        [3] {
               :class => Time < Object,
                 :now => Fri Apr 02 19:55:53 -0700 2010,
            :distance => 4.2e+43
        }
    ]

    $ cat > 2.rb
    require "awesome_print"
    data = { :now => Time.now, :class => Time.now.class, :distance => 42e42 }
    ap data, :indent => -2  # <-- Left align hash keys.
    ^D
    $ ruby 2.rb
    {
      :class    => Time < Object,
      :now      => Fri Apr 02 19:55:53 -0700 2010,
      :distance => 4.2e+43
    }

    $ cat > 3.rb
    require "awesome_print"
    data = [ false, 42, %w(forty two) ]
    data << data  # <-- Nested array.
    ap data, :multiline => false
    ^D
    $ ruby 3.rb
    [ false, 42, [ "forty", "two" ], [...] ]

    $ cat > 4.rb
    require "awesome_print"
    class Hello
      def self.world(x, y, z = nil, &blk)
      end
    end
    ap Hello.methods - Class.methods
    ^D
    $ ruby 4.rb
    [
        [0] world(x, y, *z, &blk) Hello
    ]

    $ cat > 5.rb
    require "awesome_print"
    ap (''.methods - Object.methods).grep(/!/)
    ^D
    $ ruby 5.rb
    [
        [ 0] capitalize!()           String
        [ 1]      chomp!(*arg1)      String
        [ 2]       chop!()           String
        [ 3]     delete!(*arg1)      String
        [ 4]   downcase!()           String
        [ 5]     encode!(*arg1)      String
        [ 6]       gsub!(*arg1)      String
        [ 7]     lstrip!()           String
        [ 8]       next!()           String
        [ 9]    reverse!()           String
        [10]     rstrip!()           String
        [11]      slice!(*arg1)      String
        [12]    squeeze!(*arg1)      String
        [13]      strip!()           String
        [14]        sub!(*arg1)      String
        [15]       succ!()           String
        [16]   swapcase!()           String
        [17]         tr!(arg1, arg2) String
        [18]       tr_s!(arg1, arg2) String
        [19]     upcase!()           String
    ]

    $ cat > 6.rb
    require "awesome_print"
    ap 42 == ap(42)
    ^D
    $ ruby 6.rb
    42
    true

### Example (Rails console) ###
    $ rails console
    rails> require "awesome_print"
    rails> ap Account.all(:limit => 2)
    [
        [0] #<Account:0x1033220b8> {
                         :id => 1,
                    :user_id => 5,
                :assigned_to => 7,
                       :name => "Hayes-DuBuque",
                     :access => "Public",
                    :website => "http://www.hayesdubuque.com",
            :toll_free_phone => "1-800-932-6571",
                      :phone => "(111)549-5002",
                        :fax => "(349)415-2266",
                 :deleted_at => nil,
                 :created_at => Sat, 06 Mar 2010 09:46:10 UTC +00:00,
                 :updated_at => Sat, 06 Mar 2010 16:33:10 UTC +00:00,
                      :email => "info@hayesdubuque.com",
            :background_info => nil
        },
        [1] #<Account:0x103321ff0> {
                         :id => 2,
                    :user_id => 4,
                :assigned_to => 4,
                       :name => "Ziemann-Streich",
                     :access => "Public",
                    :website => "http://www.ziemannstreich.com",
            :toll_free_phone => "1-800-871-0619",
                      :phone => "(042)056-1534",
                        :fax => "(106)017-8792",
                 :deleted_at => nil,
                 :created_at => Tue, 09 Feb 2010 13:32:10 UTC +00:00,
                 :updated_at => Tue, 09 Feb 2010 20:05:01 UTC +00:00,
                      :email => "info@ziemannstreich.com",
            :background_info => nil
        }
    ]
    rails> ap Account
    class Account < ActiveRecord::Base {
                     :id => :integer,
                :user_id => :integer,
            :assigned_to => :integer,
                   :name => :string,
                 :access => :string,
                :website => :string,
        :toll_free_phone => :string,
                  :phone => :string,
                    :fax => :string,
             :deleted_at => :datetime,
             :created_at => :datetime,
             :updated_at => :datetime,
                  :email => :string,
        :background_info => :string
    }
    rails>

### IRB integration ###
To use awesome_print as default formatter in irb and Rails console add the following
lines into your ~/.irbrc file:

	require "rubygems"
	require "awesome_print"

	unless IRB.version.include?('DietRB')
	  IRB::Irb.class_eval do
	    def output_value
	      ap @context.last_value
	    end
	  end
	else # MacRuby
	  IRB.formatter = Class.new(IRB::Formatter) do
	    def inspect_object(object)
	      object.ai
	    end
	  end.new
	end

### Logger Convenience Method ###
awesome_print adds the 'ap' method to the Logger and ActiveSupport::BufferedLogger classes
letting you call:

    logger.ap object

By default, this logs at the :debug level. You can override that globally with:

    :log_level => :info

in the custom defaults (see below). You can also override on a per call basis with:

    logger.ap object, :warn

### ActionView Convenience Method ###
awesome_print adds the 'ap' method to the ActionView::Base class making it available
within Rails templates. For example:

    <%= ap @accounts.first %>

With other web frameworks (ex: in Sinatra templates) you can explicitly request HTML
formatting:

    <%= ap @accounts.first, :html => true %>

### Setting Custom Defaults ###
You can set your own default options by creating ``.aprc`` file in your home
directory. Within that file assign your  defaults to ``AwesomePrint.defaults``.
For example:

    # ~/.aprc file.
    AwesomePrint.defaults = {
      :indent => -2,
      :color => {
        :hash  => :pale,
        :class => :white
      }
    }

### Running Specs ###

    $ gem install rspec           # RSpec 2.x is the requirement.
    $ rake spec                   # Run the entire spec suite.
    $ rspec spec/logger_spec.rb   # Run individual spec file.

### Note on Patches/Pull Requests ###
* Fork the project on Github.
* Make your feature addition or bug fix.
* Add specs for it, making sure $ rake spec is all green.
* Commit, do not mess with rakefile, version, or history.
* Send me a pull request.

### Contributors ###

* Andrew O'Brien -- https://github.com/AndrewO
* Daniel Bretoi -- http://github.com/danielb2
* Eloy Duran -- http://github.com/alloy
* Elpizo Choi -- https://github.com/fuJiin
* Benoit Daloze -- http://github.com/eregon
* Sean Gallagher -- http://github.com/torandu
* Stephan Hagemann -- https://github.com/shageman
* Tim Harper -- http://github.com/timcharper
* Tobias Crawley -- http://github.com/tobias
* Viktar Basharymau -- https://github.com/DNNX

### License ###
Copyright (c) 2010-2011 Michael Dvorkin

twitter.com/mid

%w(mike dvorkin.net) * "@" || %w(mike fatfreecrm.com) * "@"

Released under the MIT license. See LICENSE file for details.
