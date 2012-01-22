desc "Create the JSON presentation of all yoga schools"
task :json_all_schools do
  sh 'mkdir -p public/api'
  sh 'ruby lib/parse_all.rb > public/api/all_schools'
end
