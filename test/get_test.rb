##############################################################################################################
require 'helper'
 
##############################################################################################################
class GetTest < Test::Unit::TestCase
 
  #.........................................................................................................
  def setup
    @args, @client = client
  end
 
  #.........................................................................................................
  # get directory test cases
  #.........................................................................................................
  should "build request to get directory with specified name" do
    GetMessages.response_method = :dir_response
    a = @args.merge({:rpath=> 'getdir'})
    @client.get(a).should send_request(GetMessages.dir_namespace_request(a))
  end

  #.........................................................................................................
  should "build request to get directory with specified OID" do
    GetMessages.response_method = :dir_response
    a = @args.merge({:oid=> 'DIROID'})
    @client.get(a).should send_request(GetMessages.dir_objects_request(a))
  end


  #.........................................................................................................
  should "return a list of information containing OID, object type and name for each object in directory when directory name is specified" do
    GetMessages.response_method = :dir_response
    a = @args.merge({:rpath=> 'getdir'})
    res = @client.get(a)
    res[:directory].length.should be(3)
    res[:directory][0].should be(GetMessages.get_dir_result[0])
    res[:directory][1].should be(GetMessages.get_dir_result[1])
    res[:directory][2].should be(GetMessages.get_dir_result[2])
  end
 
  #.........................................................................................................
  # get file test cases
  #.........................................................................................................
  should "build request to get entire file with specified name" do
    GetMessages.response_method = :file_response
    a = @args.merge({:rpath=> 'getfile'})
    @client.get(a).should send_request(GetMessages.file_namespace_request(a))
  end

  #.........................................................................................................
  should "build request to get portion of file with specified name and byte offsets" do
    GetMessages.response_method = :file_response
    a = @args.merge({:rpath=> 'getdir/getfile', :beginoffset=>10, :endoffset=>110})
    @client.get(a).should send_request(GetMessages.file_namespace_with_offset_request(a))
  end

  #.........................................................................................................
  should "build request to get entire file with specified OID" do
    GetMessages.response_method = :file_response
    a = @args.merge({:oid=> 'FILEOID'})
    @client.get(a).should send_request(GetMessages.file_objects_request(a))
  end


  #.........................................................................................................
  should "return the entire file if only the file name is specified" do
    GetMessages.response_method = :file_response
    a = @args.merge({:rpath=> 'getfile'})
    res = @client.get(a)
  end

  #.........................................................................................................
  should "return the a portion of the file if the file name and file offsets are specified" do
    GetMessages.response_method = :file_response
    a = @args.merge({:rpath=> 'getfile', :beginoffset=>10, :endoffset=>110})
    res = @client.get(a)
  end

end
