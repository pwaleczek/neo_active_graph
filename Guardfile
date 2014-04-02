# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard :rspec, :all_on_start => true do
  watch(%r{^spec/.+_spec\.rb$})
  watch('spec/spec_helper.rb')  { "spec" }
end

