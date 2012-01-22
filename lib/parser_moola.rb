require 'rubygems'
require 'nokogiri'
require 'open-uri'
require './lib/model'
require 'json'

module Parser
  # Parser for Moola (http://moola.fi)
  class Moola
    attr_reader :doc
		@@url = "http://moola.fi/Site/Aikataulut.html"
		
		def parse
			@doc = Nokogiri::HTML(open(@@url)) 
			return self
		end

		# Returns Model::School parsed from the URL
		def get_school
			return Model::School.new(name="Moola", homepage="http://moola.fi", studios=get_studios)
		end

		# Returns an array of Model::Studios parsed from the URL
    def get_studios
      studios = Array.new # Moola has only one studio
      
      weekdays = ['MAANANTAI', 'TIISTAI', 'KESKIVIIKKO', 'TORSTAI', 'PERJANTAI', 'LAUANTAI',
      'SUNNUNTAI']
      cur_day = weekdays.fetch(0)
      classes = Array.new
      node = @doc.xpath("//p[contains('MAANANTAI', text())]")[0] # Go through all the siblings
      while node != nil
        node = node.next_sibling
        break if node == nil or node.inner_text == nil
        
        inner_text = node.inner_text.strip

        if weekdays.include? inner_text
          cur_day = inner_text # The current node represents a day of week
          next # Go to next sibling
        end

        if /\d{1,2}\.\d{2}.*/.match(inner_text)
          # Found a node that represents a yoga class
          starthour = inner_text.scan(/\d{1,2}\.\d{2}/)[0]
          endhour = inner_text.scan(/\d{1,2}\.\d{2}/)[1]
          teacher = inner_text.scan(/\((.*?)\)/)[0][0].strip
          class_name = inner_text.scan(/.*\d(.*?)\(.*/)[0][0].strip

          classes.push(Model::YogaClass.new(class_name, teacher, date=nil, dayofweek=weekdays.index(cur_day), starthour, endhour))
        end
      end

      studios.push( Model::Studio.new(name="Tehtaankatu 4b 10, Helsinki", classes))
      return studios
    end

    private

    def get_classes(weekday)
      
    end
  end
end

puts JSON.pretty_generate(Parser::Moola.new.parse.get_school.to_hash)
