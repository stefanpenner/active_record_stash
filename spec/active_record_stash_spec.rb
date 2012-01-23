require 'active_support/concern'
require 'active_record'
require 'active_model'
require './lib/active_record_stash'

conn = {
  :adapter => 'sqlite3',
  :database => 'activerecord_unittest',
  :database => 'spec/testing.sqlite3',
  :encoding => 'utf8'
}

ActiveRecord::Base.establish_connection(conn)

class Email < ActiveRecord::Base
  connection.create_table :emails, :force => true do |t|
    t.string :name
    t.text   :data
    t.timestamps
  end

#  validates_presense_of :name
  stash :phone, :address, :postal_code, :in => :data
end

describe 'ActiveRecordStash' do
  describe "new object initialization" do
    subject do
      Email.new(
        :phone        => "123456789",
        :address      => "1234 Apple way",
        :postal_code  => "13244"
      )
    end

    it { should be_valid }
    its(:phone){       should match("123456789") }
    its(:address){     should match("1234 Apple way") }
    its(:postal_code){ should match("13244") }
    its(:data){        should be_nil }

  end

  describe "object creation" do
    subject do
      @email = Email.create(
        :phone        => "123456789",
        :address      => "1234 Apple way",
        :postal_code  => "13244"
      )

      @email.reload
    end
    it { should be_valid }

    its(:phone)       { should match("123456789") }
    its(:address)     { should match("1234 Apple way") }
    its(:postal_code) { should match("13244") }
    its(:data) do
      should eql({
        :phone        =>  "123456789",
        :address      =>  "1234 Apple way",
        :postal_code  =>  "13244"
      })
    end

    describe "#update_attributes" do
      before :all do
        subject.update_attributes({
          :phone   => "2222222",
          :address => "4321 yaw elppa"
        })
      end
      its(:errors) { should_not be_any }
      its(:data)   { should_not be_empty }
      its(:data) do
        should eql({
          :phone   => "2222222",
          :address => "4321 yaw elppa",
          :postal_code => "13244"
        })
      end
      its(:phone)   { should match("2222222") }
      its(:address) { should match("4321 yaw elppa") }
      its(:postal_code) { should match("13244") }
    end
  end
end
