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
    GetMessages.response_method = :get_dir_response
    a = @args.merge({:rpath=>'newdir'})
    @client.get(a).should send_request(GetMessages.dir_namespace_request(a))
  end


  #.........................................................................................................
  should "return a list of information containing OID, object type and name for each object in directory when directory name is specified" do
    GetMessages.response_method = :get_dir_response
    a = @args.merge({:rpath=>'newdir'})
    res = @client.get(a)
    res.length.should be(3)
    res[0].should be(GetMessages.get_dir_result[0])
    res[1].should be(GetMessages.get_dir_result[1])
    res[2].should be(GetMessages.get_dir_result[2])
  end
 
end
