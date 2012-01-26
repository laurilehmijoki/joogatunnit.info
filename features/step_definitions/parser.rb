require './lib/parser_hajk'
require './lib/parser_moola'

When /^I run the parser for Helsingin astanga joogakoulu$/ do
  @hash =  Parser::HAJk.new.parse.get_school.to_hash
end

When /^I run the parser for Moola$/ do
  @hash =  Parser::Moola.new.parse.get_school.to_hash
end

Then /^the resulting JSON contains (\d+) studios?$/ do |arg0|
  raise("Parsing failed") unless @hash.fetch('studios').length == arg0.to_i
end
