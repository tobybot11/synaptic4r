####-------------------------------------------------------------------------------------------------------
module Synaptic4r
  
  ####------------------------------------------------------------------------------------------------------
  class Request
    
    ####------------------------------------------------------------------------------------------------------
    include Rest


    #.......................................................................................................
    # argument specification
    #.......................................................................................................
    define_rest_arg :uid,                 :header => :none, :cli => ['-u', '--uid uid'], 
                    :desc => 'user ID'

    define_rest_arg :key,                 :header => :none, :cli => ['-k', '--key key'], 
                    :desc => 'site generated secret key'

    define_rest_arg :site,                :header => :none, :cli => ['-s', '--site site'], 
                    :desc => 'site url'

    define_rest_arg :file,                :header => :none, :cli => ['-f', '--file file'], 
                    :desc => 'file to upload'

    define_rest_arg :oid,                 :header => :none, :cli => ['-o', '--oid oid'], 
                    :desc => 'object idetifier assigned by system'

    define_rest_arg :robj,                :header => :none, :cli => ['-r', '--remote-object [obj]'], 
                    :desc => 'name of file or directory at remote location', :map => lambda{|v| v.nil? ? true : v}

    define_rest_arg :namespace,           :header => :none, :cli => ['-n', '--namespace namespace'], 
                    :desc => 'root namespace used for remote file path (default is uid)'

    define_rest_arg :create_begin_offset, :header => :none, :cli => ['-b', '--begin-offset begin'], 
                    :desc => 'begining byte offset in file'

    define_rest_arg :create_end_offset,   :header => :none, :cli => ['-d', '--end-offset end'], 
                    :desc => 'end byte offset in file'

    define_rest_arg :content_type,        :header => :http, :cli => ['-c', '--content-type type'], 
                    :desc => 'http content type'

    define_rest_arg :beginoffset,         :header => :http, :cli => ['-b', '--begin-offset begin'], 
                    :desc => 'begining byte offset in file'

    define_rest_arg :endoffset,           :header => :http, :cli => ['-d', '--end-offset end'], 
                    :desc => 'end byte offset in file'

    define_rest_arg :useracl,             :header => :emc,  :cli => ['-a', '--user-acl acl'], 
                    :desc => 'access control list'

    define_rest_arg :groupacl,            :header => :emc,  :cli => ['-g', '--group-acl acl'], 
                    :desc => 'user group acess control list'

    define_rest_arg :tags,                :header => :emc,  :cli => ['-t', '--tags tags'], 
                    :desc => 'object tags'

    define_rest_arg :include_meta,        :header => :emc,  :cli => ['-e', '--include-meta'], 
                    :desc => 'include object metadata in query result', :map => lambda{|v| v ? 1 : 0}

    define_rest_arg :meta,                :header => :emc,  :cli => ['-m', '--metadata meta'], 
                    :desc => 'user nonlistable metadata name=value pairs'

    define_rest_arg :listable_meta,       :header => :emc,  :cli => ['-i', '--listable-metadata meta'], 
                    :desc => 'user listable metadata name=value pairs'
                                                           
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
                       :required     => [:file, [:robj, :listable_meta]], 
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
                       :required     => [:robj], 
                       :optional     => [:useracl, :groupacl, :meta, :listable_meta, :namespace],
                       :exe          => lambda {|req, args| args[:robj] += '/'}                                           

    define_rest_method :create_version, 
                       :desc          => 'create an immutable version of a file or directory',
                       :result_class  => StorageObject,
                       :http_method   => :post,
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'versions'
    
    define_rest_method :update_nonlistable_metadata, 
                       :desc          => 'update nonlistable user metadata for a file or directory',
                       :http_method   => :post,
                       :result_class  => Result,
                       :required      => [[:robj, :oid], :meta], 
                       :optional      => [:namespace],
                       :query         => 'metadata/user'

    define_rest_method :update_listable_metadata, 
                       :desc          => 'update listable user metadata for a file or directory',
                       :http_method   => :post,
                       :result_class  => Result,
                       :required      => [[:robj, :oid], :listable_meta], 
                       :optional      => [:namespace],
                       :query         => 'metadata/user'

    define_rest_method :update_acl, 
                       :desc          => 'update access control list for a file or directory',
                       :http_method   => :post,
                       :result_class  => Result,
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'acl'

    #### GET
    define_rest_method :list, 
                       :desc          => 'list the contents of a file or directory',
                       :result_class  => Download,
                       :http_method   => :get,
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace]

    define_rest_method :list_by_tag, 
                       :desc          => 'list files and directories with specified listable user metadata tag',
                       :result_class  => StorageObjectList,
                       :http_method   => :get,
                       :required      => [:tags], 
                       :optional      => [:include_meta]

    define_rest_method :list_user_metadata, 
                       :desc          => 'list user metadata for a file or directory',
                       :result_class  => UserMetadata,
                       :http_method   => :get,
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'metadata/user'

    define_rest_method :list_system_metadata, 
                       :desc          => 'list system metadata for a file or directory',
                       :http_method   => :get,
                       :result_class  => SystemMetadata,
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'metadata/system'

    define_rest_method :list_acl, 
                       :desc          => 'list user and group access control list for a file or directory',
                       :result_class  => Acl,
                       :http_method   => :get,
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'acl'

    define_rest_method :list_versions, 
                       :desc          => 'list versions of a file or directory',
                       :http_method   => :get,
                       :result_class  => Versions,
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'versions'

    define_rest_method :list_all_tags, 
                       :desc          => 'list all defined tags',
                       :http_method   => :get,
                       :result_class  => Tags,
                       :required      => [], 
                       :optional      => [:namespace, :tags],
                       :query         => 'listabletags'

    define_rest_method :list_tags, 
                       :desc          => 'list listable user metadata tags for a file or directory',
                       :http_method   => :get,
                       :result_class  => Tags,
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace],
                       :query         => 'metadata/tags'

    #### PUT
    define_rest_method :update, 
                       :desc          => 'update a file or directory',
                       :http_method   => :put,
                       :result_class  => Result,
                       :required      => [[:robj, :oid]], 
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
                       :required      => [[:robj, :oid]], 
                       :optional      => [:namespace]
    
    define_rest_method :delete_user_metadata, 
                       :desc          => 'delete user metadata for a file or directory',
                       :result_class  => Result,
                       :http_method   => :delete,
                       :required      => [[:robj, :oid], :tags], 
                       :optional      => [:namespace]

  
  #### Request
  end

#### Synaptic4r
end
