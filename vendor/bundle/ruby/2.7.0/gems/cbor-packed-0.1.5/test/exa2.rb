require 'cbor-pure'
require 'cbor-packed'
require 'cbor-diagnostic'
require 'json'
require 'yaml'

fn = "/Users/cabo/big/wot-thing-description/test-bed/data/plugfest/2017-05-osaka/MyLED_f.jsonld"
puts fn.split("/")[4..-1].join("/")
jf = File.read(fn)
puts "JSON file: #{jf.length}"
jo = JSON.parse(jf)
jsw = JSON::generate(jo, :allow_nan => true, :max_nesting => false)
# l3 jsw, "JSON no whitespace"
File.write("/tmp/jsw", jsw)

# p jo
cb = jo.to_cbor
# l3 cb, "CBOR"
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
up =  pad.to_unpacked_cbor
pp up == jo
if up != jo
  puts up.to_yaml
  puts pad.to_yaml   # get rid of unwanted sharing...
end
