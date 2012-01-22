require 'rubygems'
require './lib/parser_hajk'
require './lib/parser_moola'
require 'json'

# Print all the schools as JSON

hajk = Parser::HAJk.new.parse.get_school
moola = Parser::Moola.new.parse.get_school

puts JSON.pretty_generate({"schools" => [hajk.to_hash, moola.to_hash]})
