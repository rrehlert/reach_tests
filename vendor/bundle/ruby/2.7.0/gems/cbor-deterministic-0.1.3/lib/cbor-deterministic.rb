# -*- coding: utf-8 -*-

require "cbor" unless defined? CBOR

module CBOR
  module Deterministic

    module Object_Deterministic_CBOR
      def cbor_prepare_deterministic
        self
      end
      def to_deterministic_cbor
        cbor_prepare_deterministic.to_cbor
      end
    end
    Object.send(:include, Object_Deterministic_CBOR)

    module Array_Deterministic_CBOR
      def cbor_prepare_deterministic
        map(&:cbor_prepare_deterministic)
      end
    end
    Array.send(:include, Array_Deterministic_CBOR)

    module Hash_Deterministic_CBOR
      def cbor_prepare_deterministic
        Hash[map {|k, v|
                  k = k.cbor_prepare_deterministic
                  v = v.cbor_prepare_deterministic
                  cc = k.to_cbor # already prepared
                  [cc, k, v]}.
             sort.map{|cc, k, v| [k, v]}]
      end
    end
    Hash.send(:include, Hash_Deterministic_CBOR)

    module Tagged_Deterministic_CBOR
      def cbor_prepare_deterministic
        CBOR::Tagged.new(tag, value.cbor_prepare_deterministic)
      end
    end
    CBOR::Tagged.send(:include, Tagged_Deterministic_CBOR)
  end
end
