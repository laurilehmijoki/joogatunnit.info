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

Then /^(?:each|the) studio has at least (\d+) weekly class$/ do |arg1|
  raise("Parsing failed") unless @hash.fetch('studios').each{|studio| studio.fetch('classes').length >= arg1.to_i }
end

Then /^each class has at least name or teacher and day of week$/ do
  @hash.fetch('studios').each{|studio|
    studio.fetch('classes').each{|yogaclass|
      name = yogaclass.fetch('name')
      teacher = yogaclass.fetch('teacher')
      if (name == nil || name.strip.length == 0) && (teacher == nil || teacher.strip.length == 0)
        raise("Either name or teacher must exist")
      end

      dow = yogaclass.fetch('dayofweek')
      raise("Day of week missing") if dow == nil
    }
  }
end
