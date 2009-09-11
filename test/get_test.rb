##############################################################################################################
require 'helper'
 
##############################################################################################################
class GetTest < Test::Unit::TestCase
 
  #.........................................................................................................
  def setup
    @args, @client = client
  end
 
  #.........................................................................................................
  should "build request to get directory with specified name" do
#     a = @args.merge({:rpath=>'newdir'})
#     @client.create_dir(a).should send_request(CreateDirMessages.request(a))
  end


  #.........................................................................................................
  should "return a list of information containing OID, object type and name for each object in directory" do
#     a = @args.merge({:rpath=>'newdir'})
#     res = @client.create_dir(a)
#     res[:oid].should be(CreateDirMessages.oid)
#     res[:location].should be("/rest/objects/#{CreateDirMessages.oid}")
#     res[:date].should be(CreateDirMessages.date)
  end
 
end
