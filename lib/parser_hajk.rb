require 'rubygems'
require 'nokogiri'
require 'open-uri'

# This project
require 'model'

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

		#private

		# Returns Model::Studio parsed from the URL
		def get_studios
			studios = Array.new
			studio_title_root = @doc.xpath("//table[@class='aikataulu2']/tr/td/a[@class='citylink']/..")
			studio_title_root.each{ |frag| 
				studio_name = frag.css("a").inner_text
				studio_detail = frag.css(".graytext").inner_text
				studio = Model::Studio.new(name="#{studio_name} – #{studio_detail}")
				studios.push(studio)
			}
			return studios
		end

		def get_classes(studio)
			dowToDate = Hash.new # Keys: 0 = Monday,..., 6 = Sunday; values: dd.mm.
			root = doc.css(".aikataulu2 tr")
			
			# Map day of week to date
			root[1].css("b").each_with_index{|t, i| 
				dowToDate.store(i, /.*?(\d{1,2}\.\d{1,2}\.).*/.match(t)[1])
			}
			
			# Iterate each day's classes
			dowToClasses = Hash.new # Keys: 0 = Monday,..., 6 = Sunday; values: dd.mm. 
			root[2].css("table tr td").each_with_index{|frag, i|
				bold = frag.css("b").children
				class_name = bold.first.inner_text unless bold.first == nil
				class_name << bold.children[1].inner_text unless bold.children[1] == nil or bold.children.length == 2 
				teacher = bold.last.inner_text unless bold.last == nil
				
				startendmatch = /.*?(\d{2}:\d{2}).*(\d{2}:\d{2}).*/.match(frag.inner_text)
			
				starttime = startendmatch[1] unless startendmatch == nil
				endtime = startendmatch[2] unless startendmatch == nil
				
				puts "teacher: #{teacher}, class: #{class_name}, start: #{starttime}, end: #{endtime}"
			}

			return ""
		end
	end
end
