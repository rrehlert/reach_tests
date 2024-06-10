#require 'openssl'
require 'fileutils'
require 'benchmark'
require "benchmark/memory"



def signing

    # File paths

    # key_file = 'key.pem'
    # cert_file = 'device.crt'
    # json_file = 'tmp/json'

    system 'memusage ./signedData device.der key.der tmp/json'
end

Benchmark.bmbm do |x|
    x.report("wolfSSL signing") {signing}
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
