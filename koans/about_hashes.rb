require File.expand_path(File.dirname(__FILE__) + '/neo')

class AboutHashes < Neo::Koan
  def test_creating_hashes
    empty_hash = Hash.new
    assert_equal Hash, empty_hash.class
    assert_equal({}, empty_hash)
    assert_equal 0, empty_hash.size
  end

  def test_hash_literals
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.size
  end

  def test_accessing_hashes
    hash = { :one => "uno", :two => "dos" }
    assert_equal "uno", hash[:one]
    assert_equal "dos", hash[:two]
    assert_equal nil, hash[:doesnt_exist]
  end

  # Hash#fetch
  # Returns a value from the hash for the given key. If the key can’t be found, 
  # there are several options: With no other arguments, it will raise 
  # a KeyError exception; if default is given, then that will be returned; 
  # if the optional code block is specified, then that will 
  # be run and its result returned.

  def test_accessing_hashes_with_fetch
    hash = { :one => "uno" }
    assert_equal "uno", hash.fetch(:one)
    assert_raise(KeyError) do
      hash.fetch(:doesnt_exist)
    end

    # THINK ABOUT IT:
    #
    # Why might you want to use #fetch instead of #[] when accessing hash keys?
    # Using fetch can raise an Error (like KeyError here), but using #[] will
    # simply return nil if key is not found! Ahhhh
  end

  def test_changing_hashes
    hash = { :one => "uno", :two => "dos" }
    hash[:one] = "eins"

    expected = { :one => "eins", :two => "dos" }
    assert_equal expected, hash

    # Bonus Question: Why was "expected" broken out into a variable
    # rather than used as a literal?
    # You can't use a hash literal because the assert_equal will think
    # it's being passed a block and will throw an error, including
    # the ASCII art below! As verified on StackOverflow, you could actually
    # use the following if you like:
    # assert_equal ({ :one => "eins", :two => "dos" }, hash)
  end
#                                   ,,   ,  ,,
#                                 :      ::::,    :::,
#                    ,        ,,: :::::::::::::,,  ::::   :  ,
#                  ,       ,,,   ,:::::::::::::::::::,  ,:  ,: ,,
#             :,        ::,  , , :, ,::::::::::::::::::, :::  ,::::
#            :   :    ::,                          ,:::::::: ::, ,::::
#           ,     ,:::::                                  :,:::::::,::::,
#       ,:     , ,:,,:                                       :::::::::::::
#      ::,:   ,,:::,                                           ,::::::::::::,
#     ,:::, :,,:::                                               ::::::::::::,
#    ,::: :::::::,       Mountains are again merely mountains     ,::::::::::::
#    :::,,,::::::                                                   ::::::::::::
#  ,:::::::::::,                                                    ::::::::::::,
#  :::::::::::,                                                     ,::::::::::::
# :::::::::::::                                                     ,::::::::::::
# ::::::::::::                      Ruby Koans                       ::::::::::::
# ::::::::::::                   (in Ruby 2.1.2)                    ,::::::::::::
# :::::::::::,                                                      , :::::::::::
# ,:::::::::::::,                brought to you by                 ,,::::::::::::
# ::::::::::::::                                                    ,::::::::::::
#  ::::::::::::::,                                                 ,:::::::::::::
#  ::::::::::::,               Neo Software Artisans              , ::::::::::::
#   :,::::::::: ::::                                               :::::::::::::
#    ,:::::::::::  ,:                                          ,,:::::::::::::,
#      ::::::::::::                                           ,::::::::::::::,
#       :::::::::::::::::,                                  ::::::::::::::::
#        :::::::::::::::::::,                             ::::::::::::::::
#         ::::::::::::::::::::::,                     ,::::,:, , ::::,:::
#           :::::::::::::::::::::::,               ::,: ::,::, ,,: ::::
#               ,::::::::::::::::::::              ::,,  , ,,  ,::::
#                  ,::::::::::::::::              ::,, ,   ,:::,
#                       ,::::                         , ,,
#                                                   ,,,


  def test_hash_is_unordered
    hash1 = { :one => "uno", :two => "dos" }
    hash2 = { :two => "dos", :one => "uno" }

    assert_equal true, hash1 == hash2
  end

  # Initially I thought hash.keys.class == Symbol, but remembered
  # that hash.keys will return an Array of the keys.

  def test_hash_keys
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.keys.size
    assert_equal true, hash.keys.include?(:one)
    assert_equal true, hash.keys.include?(:two)
    assert_equal Array, hash.keys.class
  end

  # Quickly made the same mistake for hash.values.class  .. Never again! :)

  def test_hash_values
    hash = { :one => "uno", :two => "dos" }
    assert_equal 2, hash.values.size
    assert_equal true, hash.values.include?("uno")
    assert_equal true, hash.values.include?("dos")
    assert_equal Array, hash.values.class
  end

  # Hash#merge
  # Returns a new hash containing the contents of other_hash and the 
  # contents of hsh. If no block is specified, the value for entries 
  # with duplicate keys will be that of other_hash. Otherwise the value
  # for each duplicate key is determined by calling the block with the key, 
  # its value in hsh and its value in other_hash.

  def test_combining_hashes
    hash = { "jim" => 53, "amy" => 20, "dan" => 23 }
    new_hash = hash.merge({ "jim" => 54, "jenny" => 26 })

    assert_equal true, hash != new_hash

    expected = { "jim" => 54, "amy" => 20, "dan" => 23, "jenny" => 26 }
    assert_equal true, expected == new_hash
  end

  def test_default_value
    hash1 = Hash.new
    hash1[:one] = 1

    assert_equal 1, hash1[:one]
    assert_equal nil, hash1[:two]

    hash2 = Hash.new("dos")
    hash2[:one] = 1

    assert_equal 1, hash2[:one]
    assert_equal "dos", hash2[:two]
  end

  # I should've guessed by the name of the method, but apparently the default value
  # in a hash is the same object. I suppose this makes sense because all new keys
  # can simply make a reference to the same object, rather than making copies of the
  # object for each key. (See below for excerpt from official docs)

  def test_default_value_is_the_same_object
    hash = Hash.new([])

    #hash[:one] => []
    hash[:one] << "uno"
    hash[:two] << "dos"

    assert_equal ["uno", "dos"], hash[:one]
    assert_equal ["uno", "dos"], hash[:two]
    assert_equal ["uno", "dos"], hash[:three]

    assert_equal true, hash[:one].object_id == hash[:two].object_id
  end

  # Various ways to create hashes in Ruby
  # new → new_hash
  # new(obj) → new_hash
  # new {|hash, key| block } → new_hash
  # Returns a new, empty hash. If this hash is subsequently accessed by a key that 
  # doesn’t correspond to a hash entry, the VALUE RETURNED DEPENDS on the style
  # of new used to create the hash. In the first form, the access returns nil.
  # If obj is specified, this single object will be used for all default values.
  # If a block is specified, it will be called with the hash object and the key,
  # and should return the default value. It is the block’s responsibility to store 
  # the value in the hash if required.

  # In this last example, each key is being assigned the default value, which is
  # its OWN array. They are no longer referencing to the same object/array, which
  # is why the array doesn't appear to 'grow' like in the previous example.

  def test_default_value_with_block
    hash = Hash.new {|hash, key| hash[key] = [] }

    hash[:one] << "uno"
    hash[:two] << "dos"

    assert_equal ["uno"], hash[:one]
    assert_equal ["dos"], hash[:two]
    assert_equal [], hash[:three]
  end
end
