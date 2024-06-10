#!/usr/bin/env ruby
#
# This file was generated by RubyGems.
#
# The application 'cbor-diag' is installed as part of a gem, and
# this file is here to facilitate running it.
#

require 'rubygems'

version = ">= 0.a"

str = ARGV.first
if str
  str = str.b[/\A_(.*)_\z/, 1]
  if str and Gem::Version.correct?(str)
    version = str
    ARGV.shift
  end
end

if Gem.respond_to?(:activate_bin_path)
load Gem.activate_bin_path('cbor-diag', 'cborseq2pretty.rb', version)
else
gem "cbor-diag", version
load Gem.bin_path("cbor-diag", "cborseq2pretty.rb", version)
end
