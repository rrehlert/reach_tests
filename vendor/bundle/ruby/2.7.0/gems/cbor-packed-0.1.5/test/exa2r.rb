require 'cbor-pure'
require 'cbor-packed'
require 'treetop'
require 'cbor-diag-parser'
require 'cbor-diagnostic'
require 'json'
require 'yaml'

input = DATA.read


parser = CBOR_DIAGParser.new
if result = parser.parse(input)
  o = result.to_rb.to_unpacked_cbor
  puts o.cbor_diagnostic
else
  puts "*** can't parse #{i}"
  puts "*** #{parser.failure_reason}"
end

# ruby -I ../lib exa2r.rb | jq > .out1
# jq < ~/big/wot-thing-description/test-bed/data/plugfest/2017-05-osaka/MyLED_f.jsonld > .out2
# ruby .check
# => true


__END__

 51([/shared/["name", "@type", "links", "href", "mediaType",
             /  0       1       2        3         4 /
     "application/json", "outputData", {"valueType": {"type":
          /  5               6               7 /
     "number"}}, ["Property"], "writable", "valueType", "type"],
                /   8            9           10           11 /
    /prefix/ ["http://192.168.1.10", 6("3:8445/wot/thing"),
               / 6                        225 /
    225("/MyLED/"), 226("rgbValue"), "rgbValue",
      / 226             227           228     /
    {simple(6): simple(7), simple(9): true, simple(1): simple(8)}],
      / 229 /
    /suffix/ [],
    /rump/ {simple(0): "MyLED",
            "interactions": [
      229({simple(2): [{simple(3): 227("Red"), simple(4): simple(5)}],
       simple(0): 228("Red")}),
      229({simple(2): [{simple(3): 227("Green"), simple(4): simple(5)}],
       simple(0): 228("Green")}),
      229({simple(2): [{simple(3): 227("Blue"), simple(4): simple(5)}],
       simple(0): 228("Blue")}),
      229({simple(2): [{simple(3): 227("White"), simple(4): simple(5)}],
       simple(0): "rgbValueWhite"}),
      {simple(2): [{simple(3): 226("ledOnOff"), simple(4): simple(5)}],
       simple(6): {simple(10): {simple(11): "boolean"}}, simple(0):
       "ledOnOff", simple(9): true, simple(1): simple(8)},
      {simple(2): [{simple(3): 226("colorTemperatureChanged"),
       simple(4): simple(5)}], simple(6): simple(7), simple(0):
       "colorTemperatureChanged", simple(1): ["Event"]}],
      simple(1): "Lamp", "id": "0", "base": 225(""),
      "@context": 6("2:8444/wot/w3c-wot-td-context.jsonld")}])
