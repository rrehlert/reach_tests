require 'cbor-canonical'

[[1], [false], [10.3], [10.5], [Float::NAN],
 [{a: 1, b: [1, 2]}],
 [{aa: 1, b: 2}, {b: 2, aa: 1}],
 [{aa: 1, b: {mm: 2, m: 3}}, {b: {m: 3, mm: 2}, aa: 1}],
 [CBOR::Tagged.new(4711, {aa: 1, b: 2}),
  CBOR::Tagged.new(4711, {b: 2, aa: 1})],
].each do |ex1, ex2, ex3|
  c1 = ex1.to_cbor
  cc1 = ex1.to_canonical_cbor
  # p cc1
  if ex2.nil?
    raise [:eq1, c1, cc1].inspect unless c1 == cc1
  else
    raise [:ne1, c1, cc1].inspect if c1 == cc1
    c2 = ex2.to_cbor
    raise [:eq2, cc1, c2].inspect unless cc1 == c2
    cc2 = ex2.to_canonical_cbor
    raise [:eq3, cc1, cc2].inspect unless cc1 == cc2
  end
end
