## Awesome Print ##
Awesome Print is Ruby library that pretty prints Ruby objects in full color
exposing their internal structure with proper indentation. Rails ActiveRecord
objects are supported via included mixin.

### Installation ###
    $ # Installing as Ruby gem
    $ gem install awesome_print

    # Installing as Rails plugin
    $ ruby script/plugin install http://github.com/michaeldv/awesome_print_.git

    $ # Cloning the repository
    $ git clone git://github.com/michaeldv/awesome_print_.git

### Usage ###
    require "ap"
    ap(object, options = {})

    Default options:
      :miltiline => true,
      :plain  => false,
      :indent => 4,
      :colors => {
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

### Example (IRB) ###
    $ irb
    irb> require "ap"
    irb> data = [ false, 42, %w(fourty two), { :now => Time.now, :class => Time.now.class, :distance => 42e42 } ]
    irb> ap data
    [
        [0] false,
        [1] 42,
        [2] [
            [0] "fourty",
            [1] "two"
        ],
        [3] {
               :class => Time < Object,
                 :now => Fri Apr 02 19:55:53 -0700 2010,
            :distance => 4.2e+43
        }
    ]
    irb> ap data[3], :indent => -2 # Left align hash keys.
    {
      :class    => Time < Object,
      :now      => Fri Apr 02 19:55:53 -0700 2010,
      :distance => 4.2e+43
    }
    irb> ap data, :multiline => false
    [ false, 42, [ "fourty", "two" ], { :class => Time < Object, :distance => 4.2e+43, :now => Fri Apr 02 19:44:52 -0700 2010 } ]
    irb>

### Example (Rails) ###
    $ ruby script/console
    Loading development environment (Rails 2.3.5)
    rails> require "ap"
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

### Known Issues ###

* Windows...

### Note on Patches/Pull Requests ###
* Fork the project on Github.
* Make your feature addition or bug fix.
* Add specs for it, making sure $ rake spec is all green.
* Commit, do not mess with rakefile, version, or history.
* Send me a pull request.

### License ###
Copyright (c) 2010 Michael Dvorkin  
%w(mike dvorkin.net) * "@" || %w(mike fatfreecrm.com) * "@"

Released under the MIT license. See LICENSE file for details.
