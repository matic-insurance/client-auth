module AuthHelper
  def public_key
    OpenSSL::PKey::RSA.new(512)
  end

  def make_signature(key, secret_string)
    raw_signature = key.sign(OpenSSL::Digest::SHA256.new, secret_string)
    raw_signature.unpack('H*').first
  end

  def raise_authentication_error(*args)
    raise_error(*args.unshift(ClientAuth::Errors::PreconditionFailed))
  end
end

RSpec.configure do |config|
  config.include AuthHelper
end
