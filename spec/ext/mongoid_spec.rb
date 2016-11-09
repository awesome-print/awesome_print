require 'spec_helper'

RSpec.describe 'AwesomePrint/Mongoid', skip: -> { !ExtVerifier.has_mongoid? }.call do

  if ExtVerifier.has_mongoid?
    before :all do
      class MongoUser
        include Mongoid::Document

        field :first_name, type: String
        field :last_name,  type: String
      end
    end

    after :all do
      Object.instance_eval { remove_const :MongoUser }
      Object.instance_eval { remove_const :Chamelion }
    end
  end

  before do
    @ap = AwesomePrint::Inspector.new plain: true, sort_keys: true
  end

  it 'should print class instance' do
    user = MongoUser.new first_name: 'Al', last_name: 'Capone'
    out = @ap.send :awesome, user

    object_id = user.id.inspect
    str = <<-EOS.strip
#<MongoUser:placeholder_id> {
           :_id => #{object_id},
    :first_name => "Al",
     :last_name => "Capone"
}
    EOS
    expect(out).to be_similar_to(str, { skip_bson: true })
  end

  it 'should print the class' do
    class_spec = if mongoid_3_0?
                   <<-EOS.strip
class MongoUser < Object {
           :_id => :"moped/bson/object_id",
         :_type => :string,
    :first_name => :string,
     :last_name => :string
}
                   EOS
                 elsif mongoid_3_1?
                   <<-EOS.strip
class MongoUser < Object {
           :_id => :"moped/bson/object_id",
    :first_name => :string,
     :last_name => :string
}
                   EOS
                 elsif mongoid_4_0?
                   <<-EOS.strip
class MongoUser < Object {
           :_id => :"bson/object_id",
    :first_name => :string,
     :last_name => :string
}
                   EOS
                 end

    expect(@ap.send(:awesome, MongoUser)).to eq class_spec
  end

  it 'should print the class when type is undefined' do
    class Chamelion
      include Mongoid::Document
      field :last_attribute
    end

    class_spec = if mongoid_3_0?
                   <<-EOS.strip
class Chamelion < Object {
               :_id => :"moped/bson/object_id",
             :_type => :string,
    :last_attribute => :object
}
                   EOS
                 elsif mongoid_3_1?
                   <<-EOS.strip
class Chamelion < Object {
               :_id => :"moped/bson/object_id",
    :last_attribute => :object
}
                   EOS
                 elsif mongoid_4_0?
                   <<-EOS.strip
class Chamelion < Object {
               :_id => :"bson/object_id",
    :last_attribute => :object
}
                   EOS
                 end


    expect(@ap.send(:awesome, Chamelion)).to eq class_spec
  end
end
