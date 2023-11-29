# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov' # used for code-coverage highlight

SimpleCov::Formatter::LcovFormatter.config do |conf|
  conf.report_with_single_file = true
  conf.output_directory = 'coverage'
  conf.lcov_file_name = 'lcov.info'
end

SimpleCov.start do
  enable_coverage :branch
  formatter SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::LcovFormatter,
      SimpleCov::Formatter::HTMLFormatter
    ]
  )
end

require_relative '../gilded_rose'
require 'minitest/autorun'

require 'mutant/minitest/coverage'
