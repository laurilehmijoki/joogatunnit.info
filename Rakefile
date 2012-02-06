desc "Create the JSON presentation of all yoga schools"
task :json_all_schools do
  sh 'mkdir -p jekyll/api'
  sh 'ruby lib/parse_all.rb > jekyll/api/all_schools'
end

desc "Re-deploy site (builds the JSONs and uploads to S3 and CloudFront)"
task :redeploy => [:json_all_schools, :acceptance] do
  puts __FILE__
  sh 'cd jekyll;jekyll --no-auto;jekyll-s3'
end

namespace :git do
  desc "Push to remotes 'github' and 'dropbox' (branch: master)"
  task :to_remotes => [:acceptance] do
    sh 'git push dropbox master'
    sh 'git push github master'
  end
end

desc "Run the Cucumber acceptance tests"
task :acceptance do
  sh 'cucumber features/*'
end
