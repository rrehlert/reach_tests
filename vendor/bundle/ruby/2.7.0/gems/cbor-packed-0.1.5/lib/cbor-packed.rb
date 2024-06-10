# -*- coding: utf-8 -*-

require "cbor" unless defined? CBOR
# require "pp"

$compression_hack = 0

module CBOR
  PACKED_TAG = 51
  REF_TAG = 6

  REF_SIZE = [*Array.new(16, 1), *Array.new(48, 2), *Array.new(512-48, 3)]

  class Packer
    def self.from_item(item)
      count = Hash.new(0)
      item.cbor_visit do |o|
        (count[o] += 1) == 1
        # if the count gets > 1, we can stop visiting, so we return false in the block
      end
      # pp count
      # count is now a Hash with all data items as keys and the number of times they occur as values

      # choose those matches that are occurring > 1, make first rough estimate of saving
      good_count = count.select {|k, v| v > 1}.map {|k, v| [k, v, l = k.to_cbor.length,
                                                            (v-1)*(l-1)]}
      # good_count is now an array of [k, v, length, savings] tuples

      # select those that potentially have savings (> 0) and sort by best saving first
      better_count = good_count.to_a.select {|a| a[3] > 0}.sort_by {|a| -a[3]}
      # pp better_count

      # now: take the best out???; re-visit that reducing by n; re-sort and filter???

      # sort by descending number of references we'll get
      # -- the higher reference counts go first
      # then filter out the entries that actually improve

      match_array = []

      better_count.sort_by {|a| -a[1]}.each {|a|
        match_array << a[0] if (REF_SIZE[match_array.size] || 4) < a[2]
      }
      # pp match_array

      # XXX the below needs to be done with arrays and (hard!) maps as well
      # do this on the reverse to find common suffixes
      # select all strings (ignoring reference counts) and sort them
      strings = count.select {|k, v| String === k}.map(&:first).sort
      if strings != []
        string_common = strings[1..-1].zip(strings).map{ |y, x|
          l = x.chars.zip(y.chars).take_while{|a, b| a == b}.length # should be bytes
          [x, l]
        } << [strings[-1], 0]
        # string_common: list of strings/counts of number of /bytes/ matching with next
        # pp string_common
      end
      translate = {}
      prefixes = []
      if string_common
      prefix_stack = [[0, false]] # sentinel
      pos = 0                     # mirror prefix_stack[-1][0]
      tag_no = REF_TAG
      string_common.each do |s, l|
        if l > pos + 2 + $compression_hack
          if t = prefix_stack[-1][1] # if we still have a prefix left
            prefixes << CBOR::Tagged.new(t, s[pos...l])
          else
            prefixes << s[0...l]
          end
          prefix_stack << [l, tag_no]
          pos = l
          tag_no += 1
          tag_no = 225 if tag_no == REF_TAG+1
          tag_no = 28704 if tag_no == 256
        end
        if t = prefix_stack[-1][1] # if we still have a viable prefix left
          translate[s] = CBOR::Tagged.new(t, s[pos..-1])
        end
        # pop the prefix stack
        while l < pos
          prefix_stack.pop
          pos = prefix_stack[-1][0]
        end
        # pp prefix_stack
        # pp pos
      end
        
      end
      # pp translate
      # XXX test replacing match_array here
      match_array = match_array.map do |v|
        if r = translate[v]
          # puts "*** replacing #{v.inspect} by #{r.inspect}"
          r
        else
          v
        end
      end
      # pp [:PREFIXES, prefixes]
      # pp translate
      new(match_array, prefixes, [], translate)
    end
    def initialize(match_array, prefix_array, suffix_array, translate)
      @hit = translate
      # XXX: make sure we don't overwrite the existing prefix compression values!
      # (this should really be done downwards, ...) 16 x 1, 160 x 2, (512-48) x 3
      match_array[0...16].each_with_index do |o, i|
        @hit[o] = CBOR::Simple.new(i)
      end
      # if m = match_array[16...128]
      #   m.each_with_index do |o, i|
      #     @hit[o] = CBOR::Simple.new(i + 128)
      #   end
      # end
      if m = match_array[16..-1]
        m.each_with_index do |o, i|
          @hit[o] = CBOR::Tagged.new(REF_TAG, (i >> 1) ^ -(i & 1))
        end
      end
      # add one round of transitive matching
      @hit.each do |k, v|
        if r = @hit[v]
          @hit[k] = r
        end
      end
      # p @hit
      @match_array = match_array
      # @prefix = {} -- do that later
      @prefix_array = prefix_array
      @suffix_array = suffix_array
    end
    def has(o)
      @hit[o]
    end
    def pack(pa)
      # Don't forget to pack the match_array!
      CBOR::Tagged.new(PACKED_TAG, [@match_array, @prefix_array, @suffix_array, pa])
    end
  end

  class Unpacker
    def initialize(match_array, prefix_array, suffix_array)
      @simple_array = match_array[0...16]
      @tagged_array = match_array[16..-1]
      # index with 2i for i >= 0 or ~2i for i < 0
      # no map as we need to populate in progress
      # pp prefix_array
      @prefix_array = []
      prefix_array.each {|x| @prefix_array << x.to_unpacked_cbor1(self)}
      @suffix_array = []
      suffix_array.each {|x| @prefix_array << x.to_unpacked_cbor1(self)}
      # XXX order? -- must do lazily!
    end
    def unsimple(sv)
      @simple_array[sv]
    end
    def untag(i)
      # @tagged_array[(i << 1) ^ (i >> 63)]
      ix = (i << 1) ^ (i >> 63)
      ret = @tagged_array[ix]
      # warn "** UNTAG i=#{i} ix=#{ix} ret=#{ret}"
      ret
    end
    def unprefix(n)
      @prefix_array[n]
    end
    def unsuffix(n)
      @suffix_array[n]
    end
  end

  module Packed

    module Object_Packed_CBOR
      def cbor_visit
        yield self
      end
      def to_unpacked_cbor1(unpacker)
        self
      end
      def to_packed_cbor(packer = Packer.from_item(self))
        packer.pack(to_packed_cbor1(packer))
      end
      def to_packed_cbor1(packer = Packer.from_item(self))
        if c = packer.has(self)
          c
        else
          # Need to do the prefix dance, too
          self
        end
      end
    end
    Object.send(:include, Object_Packed_CBOR)

    module Simple_Packed_CBOR
      def to_unpacked_cbor1(unpacker)
        if v = unpacker.unsimple(value)
          v.to_unpacked_cbor1(unpacker)
        else
          self
        end
      end
    end
    CBOR::Simple.send(:include, Simple_Packed_CBOR)

    module String_Packed_CBOR
      def packed_merge(other, unpacker)
        # add checks
        lhs = to_unpacked_cbor1(unpacker)
        rhs = other.to_unpacked_cbor1(unpacker)
        begin
          lhs + rhs
        rescue => detail
          warn "** lhs = #{lhs.inspect}"
          warn "** rhs = #{rhs.inspect}"
          warn "** error: #{detail}"
          lhs + rhs.to_s
        end
      end
    end
    String.send(:include, String_Packed_CBOR)

    module Array_Packed_CBOR
      def cbor_visit(&b)
        if yield self
          each do |o|
            o.cbor_visit(&b)
          end
        end
      end
      def to_unpacked_cbor1(unpacker)
        map {|x| x.to_unpacked_cbor1(unpacker)}
      end
      def to_packed_cbor1(packer = Packer.from_item(self))
        if c = packer.has(self)
          c.to_packed_cbor1(packer)
        else
          # TODO: Find useful prefixes
          map {|x| x.to_packed_cbor1(packer)}
        end
      end
      def packed_merge(other, unpacker)
        # TODO: add checks
        to_unpacked_cbor1(unpacker) + other.to_unpacked_cbor1(unpacker)
      end
    end
    Array.send(:include, Array_Packed_CBOR)

    module Hash_Packed_CBOR
      def cbor_visit(&b)
        if yield self
          each do |k, v|
            k.cbor_visit(&b)
            v.cbor_visit(&b)
          end
        end
      end
      def to_unpacked_cbor1(unpacker)
        Hash[map {|k, v| [k.to_unpacked_cbor1(unpacker), v.to_unpacked_cbor1(unpacker)]}]
      end
      def to_packed_cbor1(packer = Packer.from_item(self))
        if c = packer.has(self)
          c.to_packed_cbor1(packer)
        else
          # TODO: Find useful prefixes
          Hash[map {|k, v| [k.to_packed_cbor1(packer), v.to_packed_cbor1(packer)]}]
        end
      end
      def packed_merge(other, unpacker)
        # TODO: add checks
        to_unpacked_cbor1(unpacker).merge other.to_unpacked_cbor1(unpacker)
      end
    end
    Hash.send(:include, Hash_Packed_CBOR)

    module Tagged_Packed_CBOR
      def cbor_visit(&b)
        if yield self
          value.cbor_visit(&b)
        end
      end
      def to_unpacked_cbor
        if tag == PACKED_TAG
          # check that this really is an array
          # warn value.to_yaml
          ma, pa, sa, pv = value
          unpacker = Unpacker.new(ma, pa, sa)
          pv.to_unpacked_cbor1(unpacker)
        else
          fail "error message here"
        end
      end
      def to_unpacked_cbor1(unpacker)
        case tag
        when REF_TAG
          # warn "** REF_TAG1 value #{value.class.inspect} #{value.inspect}"
          unpacked_value = value.to_unpacked_cbor1(unpacker)
          # warn "** REF_TAG2 value #{unpacked_value.class.inspect} #{unpacked_value.inspect}"
          if Integer === unpacked_value
            # warn "** I REF_TAG value #{value.class.inspect} #{value.inspect}"
            unpacker.untag(unpacked_value)
          else
            unpacker.unprefix(0).packed_merge unpacked_value, unpacker
          end
        when 225...256
          unpacker.unprefix(tag-(256-32)).packed_merge value, unpacker
        when 28704...32768      # (- 28704 (- 32768 4096)) == 32
          unpacker.unprefix(tag-(32768-4096)).packed_merge value, unpacker
        when 1879052288...2147483648 # (- 1879052288 (- 2147483648 268435456)) == 4096
          unpacker.unprefix(tag-(2147483648-268435456)).packed_merge value, unpacker
        when 216...224
          value.packed_merge unpacker.unsuffix(tag-216), unpacker
        when 27647...28672
          value.packed_merge unpacker.unsuffix(tag-(28672-1024)), unpacker
        when 1811940352...1879048192
          value.packed_merge unpacker.unsuffix(tag-(1879048192-67108864)), unpacker
        else
          CBOR::Tagged.new(tag, value.to_unpacked_cbor1(unpacker))
        end
      end
      def to_packed_cbor1(packer = Packer.from_item(self))
        if c = packer.has(self)
          c
        else
          CBOR::Tagged.new(tag, value.to_packed_cbor1(packer))
        end
      end
    end
    CBOR::Tagged.send(:include, Tagged_Packed_CBOR)
  end
end
