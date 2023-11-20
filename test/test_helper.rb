# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

require_relative '../gilded_rose'
require 'minitest/autorun'

SimpleCov::Formatter::LcovFormatter.config do |c|
  c.report_with_single_file = true
  c.output_directory = 'coverage'
  c.lcov_file_name = 'lcov.info'
end
SimpleCov.start do
  enable_coverage :branch
  formatter SimpleCov::Formatter::MultiFormatter.new([
                                                       SimpleCov::Formatter::LcovFormatter,
                                                       SimpleCov::Formatter::HTMLFormatter
                                                     ])
end
