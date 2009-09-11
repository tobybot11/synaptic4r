##############################################################################################################
require 'helper'
 
##############################################################################################################
class CreateDirTest < Test::Unit::TestCase
 
  #.........................................................................................................
  def setup
    @args, @client = client
  end
 
  #.........................................................................................................
  should "build request to create directory with specified name" do
    a = @args.merge({:rpath=>'newdir'})
    @client.create_dir(a).should send_request(CreateDirMessages.request(a))
  end


  #.........................................................................................................
  should "return OID, location and creation date for created directory" do
    a = @args.merge({:rpath=>'newdir'})
    res = @client.create_dir(a)
    res[:oid].should be(CreateDirMessages.oid)
    res[:location].should be("/rest/objects/#{CreateDirMessages.oid}")
    res[:date].should be(CreateDirMessages.date)
  end
 
end
