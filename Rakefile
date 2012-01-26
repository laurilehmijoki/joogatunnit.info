desc "Create the JSON presentation of all yoga schools"
task :json_all_schools do
  sh 'mkdir -p site/api'
  sh 'ruby lib/parse_all.rb > jekyll/api/all_schools'
end

desc "Re-deploy site (builds the JSONs and uploads to S3 and CloudFront)"
task :redeploy => [:json_all_schools] do
  puts __FILE__
  sh 'cd jekyll;jekyll-s3'
end

desc "Push to remotes 'github' and 'dropbox' (branch: master)"
namespace :git do
  task :to_remotes
    sh 'git push dropbox master'
    sh 'git push github master'
  end
end
