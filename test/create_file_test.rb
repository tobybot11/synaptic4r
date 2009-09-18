##############################################################################################################
require 'helper'
 
##############################################################################################################
class CreateFileTest < Test::Unit::TestCase
 
  #.........................................................................................................
  def setup
    @args, @client = client
  end
 
  #.........................................................................................................
  should "build request to create file with specified name and read entire file from disk when local file name is specified" do
    CreateFileMessages.response_method = :file_response
    a = @args.merge({:rpath=>'test.text', :file => 'test/test.txt', :payload => true})
    @client.create_file(a).should send_request(CreateFileMessages.namespace_request(a))
  end

  #.........................................................................................................
  should "build request to create file with specified listable metadata and read entire file from disk when local file name is specified" do
    CreateFileMessages.response_method = :file_response
    a = @args.merge({:listable_meta=>'test', :file => 'test/test.txt', :payload => true})
    @client.create_file(a).should send_request(CreateFileMessages.listable_metadata_request(a))
  end

  #.........................................................................................................
  should "build request to create file with specified name and read entire file from disk when file IO object specified" do
    CreateFileMessages.response_method = :file_response
    full_payload = File.new('test/test.txt')
    a = @args.merge({:rpath=>'test.text', :file => full_payload, :payload => true})
    @client.create_file(a).should send_request(CreateFileMessages.namespace_request(a))
  end

  #.........................................................................................................
  should "return OID, location and creation date for created file when entire file is uploaded" do
    CreateFileMessages.response_method = :file_response
    a = @args.merge({:listable_meta=>'test', :file => 'test/test.txt', :payload => true})
    res = @client.create_file(a)
    res[:oid].should be(CreateFileMessages.oid)
    res[:location].should be("/rest/objects/#{CreateFileMessages.oid}")
    res[:date].should be(CreateFileMessages.date)
    res[:size].should be(CreateFileMessages.full_size)
  end
 
end
