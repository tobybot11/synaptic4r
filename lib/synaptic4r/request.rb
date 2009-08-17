####-------------------------------------------------------------------------------------------------------
module Synaptic4r
  
  ####------------------------------------------------------------------------------------------------------
  class Request
    
    ####------------------------------------------------------------------------------------------------------
    include Rest


    #.......................................................................................................
    # argument specification
    #.......................................................................................................
    define_rest_arg :uid,                 :header => :hide

    define_rest_arg :key,                 :header => :hide

    define_rest_arg :site,                :header => :hide

    define_rest_arg :file,                :header => :none, :cli => 'file', 
                    :desc => 'file to upload'

    define_rest_arg :account,             :header => :none, :cli => ['account', '-u'], 
                    :desc => "user account name specified in #{ENV['HOME']}./synaptic4r"

    define_rest_arg :oid,                 :header => :none, :cli => ['oid', '-o'], 
                    :desc => 'system assigned object identifier'

    define_rest_arg :rpath,               :header => :none, :cli => 'rpath', 
                    :desc => 'remote file or directory path'

    define_rest_arg :namespace,           :header => :none, :cli => ['namespace', '-n'], 
                    :desc => 'root namespace used for remote file path (default is uid)'

    define_rest_arg :create_beginoffset, :header => :none, :cli => ['beginoffset', '-b'],
                    :desc => 'begining byte offset in file'
 
    define_rest_arg :create_endoffset, :header => :none,   :cli => ['endoffset', '-d'],
                    :desc => 'end byte offset in file'

    define_rest_arg :content_type,        :header => :http, :cli => ['content-type', '-c'], 
                    :desc => 'http content type'

    define_rest_arg :beginoffset,         :header => :http, :cli => ['beginoffset', '-b'], 
                    :desc => 'begining byte offset in file'

    define_rest_arg :endoffset,           :header => :http, :cli => ['endoffset', '-d'], 
                    :desc => 'end byte offset in file'

    define_rest_arg :useracl,             :header => :emc,  :cli => ['useracl', '-a'], 
                    :desc => 'access control list'

    define_rest_arg :groupacl,            :header => :emc,  :cli => ['groupacl', '-g'], 
                    :desc => 'user group acess control list'

    define_rest_arg :tags,                :header => :emc,  :cli => ['tags', '-t'], 
                    :desc => 'listable metadata tag name'

    define_rest_arg :include_meta,        :header => :emc,  :cli => ['include-meta', '-e', :flag], 
                    :desc => 'include object metadata in query result', :map => lambda{|v| v ? 1 : 0}

    define_rest_arg :meta,                :header => :emc,  :cli => ['meta', '-m'], 
                    :desc => 'user nonlistable metadata name=value pairs'

    define_rest_arg :listable_meta,       :header => :emc,  :cli => ['listable-meta', '-i'], 
                    :desc => 'user listable metadata tag name=value pairs'
                                                           
    #.......................................................................................................
    # method specification
    #.......................................................................................................
    #### all methods
    define_rest_method :all, 
                       :required => [:uid, :key, :site], 
                       :optional => [:account]

    #### POST
    define_rest_method :create_file, 
                       :desc              => 'create a file',
                       :result_class      => StorageObject,
                       :http_method       => :post,
                       :required          => [:file, [:rpath, :listable_meta]], 
                       :optional          => [:content_type, :namespace, :create_beginoffset, :create_endoffset],
                       :exe               => lambda {|req, args| 
                                                    ext = req.extent(args[:file], args[:create_beginoffset], 
                                                              args[:create_endoffset])
                                                    req.add_payload(args, ext)},
                       :map_required_args => lambda {|vals|
                                                     pvals = vals.select{|v| /^-i/.match(v) or not /^-/.match(v)}
                                                     ovals = if pvals.length.eql?(1)
                                                               pvals + [pvals.first] 
                                                             elsif /\/$/.match(pvals.last) and pvals.length.eql?(2)
                                                               [pvals.first, pvals.last+File.basename(pvals.first)]
                                                             else
                                                               pvals
                                                             end
                                                     {:pvals => ovals, :dlen => ovals.length - pvals.length}},
                       :banner            => 'Usage: synrest create-file file [remote-path|-i list-meta] [options]'

    define_rest_method :create_dir, 
                       :desc              => 'create a directory',
                       :result_class      => StorageObject,
                       :http_method       => :post,
                       :required          => [:rpath], 
                       :optional          => [:namespace],
                       :exe               => lambda {|req, args| args[:rpath] += '/'}  

    define_rest_method :create_version, 
                       :desc              => 'create an immutable version of a file or directory',
                       :result_class      => StorageObject,
                       :http_method       => :post,
                       :required          => [[:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'versions'
    
    define_rest_method :update_nonlistable_metadata, 
                       :desc              => 'update nonlistable user metadata for a file or directory',
                       :http_method       => :post,
                       :result_class      => Result,
                       :required          => [:meta, [:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'metadata/user'

    define_rest_method :update_listable_metadata, 
                       :desc              => 'update listable user metadata for a file or directory',
                       :http_method       => :post,
                       :result_class      => Result,
                       :required          => [:listable_meta, [:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'metadata/user'

    define_rest_method :update_acl, 
                       :desc              => 'update access control list for a file or directory',
                       :http_method       => :post,
                       :result_class      => Result,
                       :required          => [[:useracl, :groupacl], [:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'acl'

    #### GET
    define_rest_method :get, 
                       :desc              => 'get the contents of a file or directory',
                       :result_class      => Download,
                       :http_method       => :get,
                       :required          => [[:rpath, :oid]], 
                       :optional          => [:namespace],
                       :map_required_args => lambda {|vals| 
                                                      pvals = vals.select{|v| /^-o/.match(v) or not /^-/.match(v)}
                                                      if pvals.empty?
                                                        {:pvals => [''], :dlen => 1}
                                                      else
                                                        {:pvals => pvals, :dlen => 0}
                                                      end},
                       :banner            => 'Usage: synrest get [remote-path|-o oid] [options]'

    define_rest_method :get_by_tag, 
                       :desc              => 'get files and directories with specified listable user metadata tag',
                       :result_class      => StorageObjectList,
                       :http_method       => :get,
                       :required          => [:tags], 
                       :optional          => [:include_meta]


    define_rest_method :get_user_metadata, 
                       :desc              => 'get both listable and nonlistable user metadata for a file or directory',
                       :result_class      => UserMetadata,
                       :http_method       => :get,
                       :required          => [[:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'metadata/user'

    define_rest_method :get_system_metadata, 
                       :desc              => 'get system metadata for a file or directory',
                       :http_method       => :get,
                       :result_class      => SystemMetadata,
                       :required          => [[:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'metadata/system'

    define_rest_method :get_acl, 
                       :desc              => 'get user and group access control list for a file or directory',
                       :result_class      => Acl,
                       :http_method       => :get,
                       :required          => [[:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'acl'

    define_rest_method :get_versions, 
                       :desc              => 'get versions of a file or directory',
                       :http_method       => :get,
                       :result_class      => Versions,
                       :required          => [[:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'versions'

    define_rest_method :get_all_tags, 
                       :desc              => 'get all defined tags',
                       :http_method       => :get,
                       :result_class      => Tags,
                       :required          => [], 
                       :optional          => [:namespace, :tags],
                       :query             => 'listabletags'


    define_rest_method :get_tags, 
                       :desc              => 'get listable user metadata tags for a file or directory',
                       :http_method       => :get,
                       :result_class      => Tags,
                       :required          => [[:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'metadata/tags'

    #### PUT
    define_rest_method :update, 
                       :desc              => 'update a file or directory',
                       :http_method       => :put,
                       :result_class      => Result,
                       :required          => [:file, [:rpath, :oid]], 
                       :optional          => [:namespace, :beginoffset, :endoffset],
                       :exe               => lambda {|req, args| 
                                                     ext = req.extent(args[:file], args[:beginoffset], args[:endoffset])
                                                     req.set_header_range(args, ext)
                                                     req.add_payload(args, ext)
                                                     req.set_header_extent(args, ext)},
                       :map_required_args => lambda {|vals|
                                                     pvals = vals.select{|v| not /^-/.match(v)}
                                                     ovals = if pvals.length.eql?(1)
                                                               pvals + [pvals.first] 
                                                             elsif /\/$/.match(pvals.last) and pvals.length.eql?(2)
                                                               [pvals.first, pvals.last+File.basename(pvals.first)]
                                                             else
                                                               pvals
                                                             end
                                                     {:pvals => ovals, :dlen => ovals.length - pvals.length}},
                        :banner            => 'Usage: synrest update file [remote-path|-o oid] [options]'

    #### DELETE    
    define_rest_method :delete, 
                       :desc              => 'delete a file or directory',
                       :result_class      => Result,
                       :http_method       => :delete,
                       :required          => [[:rpath, :oid]], 
                       :optional          => [:namespace]
    
    define_rest_method :delete_user_metadata, 
                       :desc              => 'delete user metadata for a file or directory',
                       :result_class      => Result,
                       :http_method       => :delete,
                       :required          => [:tags, [:rpath, :oid]], 
                       :optional          => [:namespace],
                       :query             => 'metadata/user'

  
  #### Request
  end

#### Synaptic4r
end
