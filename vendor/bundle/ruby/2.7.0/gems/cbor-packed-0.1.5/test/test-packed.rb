require 'cbor-pure'
require 'cbor-packed'
require 'cbor-diagnostic'
require 'json'
require 'yaml'
require 'zlib'
require 'lz4-ruby'

def l3(bin, desc)
  puts "#{desc}: #{bin.length}, deflate: #{Zlib.deflate(bin, Zlib::BEST_COMPRESSION).length}, lz4: #{LZ4::compress(bin).length}, lz4hc: #{LZ4::compressHC(bin).length}"
end

fn = "/Users/cabo/big/wot-thing-description/test-bed/data/plugfest/2017-05-osaka/MyLED_f.jsonld"
puts fn.split("/")[4..-1].join("/")
jf = File.read(fn)
puts "JSON file: #{jf.length}"
jo = JSON.parse(jf)
jsw = JSON::generate(jo, :allow_nan => true, :max_nesting => false)
l3 jsw, "JSON no whitespace"
File.write("/tmp/jsw", jsw)

# p jo
cb = jo.to_cbor
l3 cb, "CBOR"
$compression_hack = 1000
pa = jo.to_packed_cbor
cbp = pa.to_cbor
# l3 cbp, "CBOR packed"
puts "CBOR packed (sharing only): #{cbp.length}"
$compression_hack = 0
pa = jo.to_packed_cbor
cbp = pa.to_cbor
# l3 cbp, "CBOR packed"
puts "CBOR packed: #{cbp.length}"
File.write("/tmp/cbp", cbp)
File.write("/tmp/cbu", cb)
pad = CBOR.decode(cbp)
# puts pad.to_yaml
up =  pad.to_unpacked_cbor
pp up == jo
if up != jo
  puts up.to_yaml
  puts pad.to_yaml   # get rid of unwanted sharing...
end

# puts "#{pa.value.map {|x| x.to_cbor.length}}"
puts pa.value[1].to_json

exin = JSON.load(DATA)
exout = exin.to_packed_cbor
p CBOR.encode(exin).length, CBOR.encode(exout).length
puts exout.cbor_diagnostic
if exin != exout.to_unpacked_cbor
  fail exout.inspect
end

exit

# $compression_hack = 1000

a1 = {"aaaa" => "aaaaaaaa", "aaaaaaaaaaaa" => "aaaa", "aaaaaaaa" => "aaaaaaaaaaaa"}
pa1 = a1.to_packed_cbor
puts pa1.to_yaml
a1u = pa1.to_unpacked_cbor
if a1u != a1
  puts a1u.to_yaml
end

__END__

{ "store": {
    "book": [ 
      { "category": "reference",
        "author": "Nigel Rees",
        "title": "Sayings of the Century",
        "price": 8.95
      },
      { "category": "fiction",
        "author": "Evelyn Waugh",
        "title": "Sword of Honour",
        "price": 12.99
      },
      { "category": "fiction",
        "author": "Herman Melville",
        "title": "Moby Dick",
        "isbn": "0-553-21311-3",
        "price": 8.95
      },
      { "category": "fiction",
        "author": "J. R. R. Tolkien",
        "title": "The Lord of the Rings",
        "isbn": "0-395-19395-8",
        "price": 22.99
      }
    ],
    "bicycle": {
      "color": "red",
      "price": 19.95
    }
  }
}
