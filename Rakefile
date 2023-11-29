require 'rake/testtask'

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib' << 'test'
  t.verbose = true
  t.pattern = 'test/**/*_test.rb' # tests inside test subfolder
end                               # and end with '_test.rb'
# Run all test with `rake test`

task default: :test # run tests with just `rake`
