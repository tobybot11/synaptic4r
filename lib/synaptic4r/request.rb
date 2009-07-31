####-------------------------------------------------------------------------------------------------------
module Synaptic4r
  
  ####------------------------------------------------------------------------------------------------------
  class Request
    
    ####------------------------------------------------------------------------------------------------------
    include Rest


    #.......................................................................................................
    # argument specification
    #.......................................................................................................
    define_rest_arg :uid,                 :header => :none

    define_rest_arg :key,                 :header => :none

    define_rest_arg :site,                :header => :none

    define_rest_arg :file,                :header => :none, :cli_arg => 'file', 
                    :desc => 'file to upload'

    define_rest_arg :oid,                 :header => :none, :cli_arg => '-o oid', 
                    :desc => 'system assigned object identifier'

    define_rest_arg :rpath,               :header => :none, :cli_arg => 'remote-path', 
                    :desc => 'remote file or directory path', :map => lambda{|v| v.nil? ? true : v}

    define_rest_arg :namespace,           :header => :none, :cli_opt => ['-n', '--namespace namespace'], 
                    :desc => 'root namespace used for remote file path (default is uid)'

    define_rest_arg :create_begin_offset, :header => :none, :cli_opt => ['-b', '--begin-offset begin'], 
                    :desc => 'begining byte offset in file'

    define_rest_arg :create_end_offset,   :header => :none, :cli_opt => ['-d', '--end-offset end'], 
                    :desc => 'end byte offset in file'

    define_rest_arg :content_type,        :header => :http, :cli_opt => ['-c', '--content-type type'], 
                    :desc => 'http content type'

    define_rest_arg :beginoffset,         :header => :http, :cli_opt => ['-b', '--begin-offset begin'], 
                    :desc => 'begining byte offset in file'

    define_rest_arg :endoffset,           :header => :http, :cli_opt => ['-d', '--end-offset end'], 
                    :desc => 'end byte offset in file'

    define_rest_arg :useracl,             :header => :emc,  :cli_opt => ['-a', '--user-acl acl'], 
                    :desc => 'access control list'

    define_rest_arg :groupacl,            :header => :emc,  :cli_opt => ['-g', '--group-acl acl'], 
                    :desc => 'user group acess control list'

    define_rest_arg :tags,                :header => :emc,  :cli_opt => ['-t', '--tags tags'], 
                    :desc => 'object tags'

    define_rest_arg :include_meta,        :header => :emc,  :cli_opt => ['-e', '--include-meta'], 
                    :desc => 'include object metadata in query result', :map => lambda{|v| v ? 1 : 0}

    define_rest_arg :meta,                :header => :emc,  :cli_opt => ['-m', '--metadata metadata'], 
                    :desc => 'user nonlistable metadata name=value pairs'

    define_rest_arg :listable_meta,       :header => :emc,  :cli_opt => ['-i', '--listable-metadata metadata'], 
                    :cli_arg => '-i listable-metadata', :desc => 'user listable metadata name=value pairs'
                                                           
    #.......................................................................................................
    # method specification
    #.......................................................................................................
    #### all methods
    define_rest_method :all, 
                       :required => [:uid, :key, :site], 
                       :optional => []

    #### POST
    define_rest_method :create_file, 
                       :desc         => 'create a file',
                       :result_class => StorageObject,
                       :http_method  => :post,
                       :required     => [:file, [:rpath, :listable_meta]], 
                       :optional     => [:useracl, :groupacl, :meta, :content_type, :namespace, 
                                         :create_begin_offset, :create_end_offset],
                       :exe          => lambda {|req, args| 
                                                 ext = req.extent(args[:file], args[:create_begin_offset], 
                                                              args[:create_end_offset])
                                                 req.add_payload(args, ext)}
    define_rest_method :create_dir, 
                       :desc         => 'create a directory',
                       :result_class => StorageObject,
                       :http_method  => :post,
                       :required     => [:rpath], 
                       :optional     => [:useracl, :groupacl, :meta, :listable_meta, :namespace],
                       :exe          => lambda {|req, args| args[:rpath] += '/'}                                           

    define_rest_method :create_version, 
                       :desc          => 'create an immutable version of a file or directory',
                       :result_class  => StorageObject,
                       :http_method   => :post,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'versions'
    
    define_rest_method :update_nonlistable_metadata, 
                       :desc          => 'update nonlistable user metadata for a file or directory',
                       :http_method   => :post,
                       :result_class  => Result,
                       :required      => [[:rpath, :oid], :meta], 
                       :optional      => [:namespace],
                       :query         => 'metadata/user'

    define_rest_method :update_listable_metadata, 
                       :desc          => 'update listable user metadata for a file or directory',
                       :http_method   => :post,
                       :result_class  => Result,
                       :required      => [[:rpath, :oid], :listable_meta], 
                       :optional      => [:namespace],
                       :query         => 'metadata/user'

    define_rest_method :update_acl, 
                       :desc          => 'update access control list for a file or directory',
                       :http_method   => :post,
                       :result_class  => Result,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'acl'

    #### GET
    define_rest_method :get, 
                       :desc          => 'get the contents of a file or directory',
                       :result_class  => Download,
                       :http_method   => :get,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace]

    define_rest_method :get_by_tag, 
                       :desc          => 'get files and directories with specified listable user metadata tag',
                       :result_class  => StorageObjectList,
                       :http_method   => :get,
                       :required      => [:tags], 
                       :optional      => [:include_meta]

    define_rest_method :get_user_metadata, 
                       :desc          => 'get both listable and nonlistable user metadata for a file or directory',
                       :result_class  => UserMetadata,
                       :http_method   => :get,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'metadata/user'

    define_rest_method :get_system_metadata, 
                       :desc          => 'get system metadata for a file or directory',
                       :http_method   => :get,
                       :result_class  => SystemMetadata,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'metadata/system'

    define_rest_method :get_acl, 
                       :desc          => 'get user and group access control list for a file or directory',
                       :result_class  => Acl,
                       :http_method   => :get,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'acl'

    define_rest_method :get_versions, 
                       :desc          => 'get versions of a file or directory',
                       :http_method   => :get,
                       :result_class  => Versions,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'versions'

    define_rest_method :get_all_tags, 
                       :desc          => 'get all defined tags',
                       :http_method   => :get,
                       :result_class  => Tags,
                       :required      => [], 
                       :optional      => [:namespace, :tags],
                       :query         => 'listabletags'

    define_rest_method :get_tags, 
                       :desc          => 'get listable user metadata tags for a file or directory',
                       :http_method   => :get,
                       :result_class  => Tags,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'metadata/tags'

    #### PUT
    define_rest_method :update, 
                       :desc          => 'update a file or directory',
                       :http_method   => :put,
                       :result_class  => Result,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:useracl, :groupacl, :meta, :listable_meta, :content_type, 
                                          :namespace, :file, :beginoffset, :endoffset],
                       :exe           => lambda {|req, args| 
                                                 ext = req.extent(args[:file], args[:beginoffset], args[:endoffset])
                                                 req.set_header_range(args, ext)
                                                 req.add_payload(args, ext)
                                                 req.set_header_extent(args, ext)}

    #### DELETE    
    define_rest_method :delete, 
                       :desc          => 'delete a file or directory',
                       :result_class  => Result,
                       :http_method   => :delete,
                       :required      => [[:rpath, :oid]], 
                       :optional      => [:namespace]
    
    define_rest_method :delete_user_metadata, 
                       :desc          => 'delete user metadata for a file or directory',
                       :result_class  => Result,
                       :http_method   => :delete,
                       :required      => [[:rpath, :oid], :tags], 
                       :optional      => [:namespace]

  
  #### Request
  end

#### Synaptic4r
end
