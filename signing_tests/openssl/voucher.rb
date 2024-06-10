require 'openssl'
require 'fileutils'
require 'benchmark'
require "benchmark/memory"



def signing

    # File paths

    key_file = 'key.pem'
    cert_file = 'device.crt'
    json_file = 'tmp/json'

    # Step 1: Load the private key from key.pem
    privkey = OpenSSL::PKey.read(File.read(key_file))

    # Step 2: Load the signing certificate from device.crt
    signing_cert = OpenSSL::X509::Certificate.new(File.read(cert_file))

    # Step 3: Load the JSON data from out1.txt
    json = File.read(json_file)

    # Additional parameters
    extracerts = nil  # Assuming extracerts is not provided in the code snippet
    flags = OpenSSL::CMS::NOSMIMECAP
    digest = OpenSSL::Digest::SHA256.new

    # Step 4: Sign the JSON data using the private key and the signing certificate
    smime = OpenSSL::CMS.sign(signing_cert, privkey, json, extracerts, flags)

    # Step 5: Convert the signed data to DER format
    @token = smime.to_der

    # Output the result to a file (optional)
    #File.open('smime', 'wb') { |file| file.write(smime) }
    File.open('tmp/smime.der', 'wb') { |file| file.write(@token) }
end

Benchmark.bmbm do |x|
    x.report("OpenSSL signing") {signing}
end
Benchmark.memory do |x|
    x.report("OpenSSL signing") {signing}
end


# # Benchmark execution time
# time_result = Benchmark.measure do
# signing
# end

# # Benchmark memory usage
# memory_result = Benchmark.memory do
# signing
# end

# puts "Execution Time:"
# puts time_result

# puts "\nMemory Usage:"
# puts memory_result
