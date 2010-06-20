require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

conn = { 
  :adapter => 'sqlite3',
  :database => 'activerecord_unittest',
  :database => '../testing.sqlite3',
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

describe ActiveRecord::Stash do
  describe "new object initialization" do
    before(:all) do
      @email = Email.new(
        :phone        => "123456789", 
        :address      => "1234 Apple way", 
        :postal_code  => "13244"
      )
    end

    it "is a valid object" do
      @email.should be_valid
    end

    it "has all the correct forward facing attributes" do
      @email.phone.should match("123456789")
      @email.address.should match("1234 Apple way")
      @email.postal_code.should match("13244")
    end

    it "has an empty data column" do
      @email.data.should be_nil
    end

    describe "save" do 
      it "is successful" do
        @email.save.should be_true
      end

      it "still has the correct forward facing attributes" do
        @email.phone.should match("123456789")
        @email.address.should match("1234 Apple way")
        @email.postal_code.should match("13244")
      end

      it "does not have an empty data column" do
        @email.data.should_not be_nil
      end

      it "has the correct serialized data in the serialized column" do
        @email.data.should_not be_empty

        @email.data.should eql({
          :phone        =>  "123456789", 
          :address      =>  "1234 Apple way", 
          :postal_code  =>  "13244"
        })
      end
    end
  end
end
