require 'rubygems'
require 'nokogiri'
require 'open-uri'

# This project
require 'model'
require 'yaml'

module Parser
	# Parser for Helsingin astanga joogakoulu (astanga.fi)
	class HAJk
		attr_reader :doc
		@@url = "http://astanga.fi/helsinki/aikataulut"
		
		def parse
			@doc = Nokogiri::HTML(open(@@url)) 
			return self
		end

		# Returns Model::School parsed from the URL
		def get_school
			return Model::School.new(name="Helsingin astanga joogakoulu", homepage="http://astanga.fi", studios=get_studios)
		end

		# Returns an array of Model::Studios parsed from the URL
		def get_studios
			studios = Array.new
			doc.css(".aikataulu2").each {|studio_frag|

				studio_name = studio_frag.css(".citylink").inner_text
				studio_detail = studio_frag.css(".graytext").inner_text
				
				studio = Model::Studio.new(name="#{studio_name} – #{studio_detail}")
				studios.push(studio)
					
				dowToDate = Hash.new # Keys: 0 = Monday,..., 6 = Sunday; values: dd.mm.
				
				# Map day of week to date
				studio_frag.css(".navimenu b").each_with_index{|t, i| 
					dowToDate.store(i, /.*?(\d{1,2}\.\d{1,2}\.).*/.match(t)[1])
				}
				
				classes = Array.new
				# Iterate each day's classes
				studio_frag.css("table").each_with_index{|day, i|
					day.css("tr td").each{|frag|
						bold = frag.css("b").children
						class_name = bold.first.inner_text unless bold.first == nil
						class_name << bold.children[1].inner_text unless bold.children[1] == nil or bold.children.length == 2 
						teacher = bold.last.inner_text unless bold.last == nil
						
						starttime = nil
						endtime = nil
						frag.inner_text.scan(/(\d{2}:\d{2})/) { |m|
							starttime = m[0] if starttime == nil
							endtime = m[0]
						}
					
						classes.push(Model::YogaClass.new(class_name, teacher, dowToDate.fetch(i), i, starttime, endtime)) unless class_name == nil or teacher == nil
							
					}
				}

				studio.classes = classes

			}
			return studios
		end
	end
end

puts Parser::HAJk.new.parse.get_school.studios[1].to_yaml
