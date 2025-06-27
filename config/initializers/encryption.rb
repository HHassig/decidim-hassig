# raw_key = ENV["ENCRYPTION_KEY"] || Rails.application.credentials.encryption_key
# raise "Missing encryption key" unless raw_key

# key = if raw_key.match?(/\A[0-9a-f]{32}\z/i)
#   [raw_key].pack("H*")  # convert hex string to raw bytes
# elsif raw_key.bytesize == 16
#   raw_key  # already raw bytes
# else
#   raise "Encryption key must be a 16-byte string or 32-character hex"
# end

# $encryptor = ActiveSupport::MessageEncryptor.new(key)
