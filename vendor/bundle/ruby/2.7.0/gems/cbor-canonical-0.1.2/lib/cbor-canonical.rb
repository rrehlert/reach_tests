# -*- coding: utf-8 -*-

require "cbor" unless defined? CBOR

module CBOR
  module Canonical

    module Object_Canonical_CBOR
      def cbor_pre_canonicalize
        self
      end
      def to_canonical_cbor
        cbor_pre_canonicalize.to_cbor
      end
    end
    Object.send(:include, Object_Canonical_CBOR)

    module Array_Canonical_CBOR
      def cbor_pre_canonicalize
        map(&:cbor_pre_canonicalize)
      end
    end
    Array.send(:include, Array_Canonical_CBOR)

    module Hash_Canonical_CBOR
      def cbor_pre_canonicalize
        Hash[map {|k, v| 
                  k = k.cbor_pre_canonicalize
                  v = v.cbor_pre_canonicalize
                  cc = k.to_cbor # already canonical
                  [cc.size, cc, k, v]}.
             sort.map{|s, cc, k, v| [k, v]}]
      end
    end
    Hash.send(:include, Hash_Canonical_CBOR)

    module Tagged_Canonical_CBOR
      def cbor_pre_canonicalize
        CBOR::Tagged.new(tag, value.cbor_pre_canonicalize)
      end
    end
    CBOR::Tagged.send(:include, Tagged_Canonical_CBOR)
  end
end
