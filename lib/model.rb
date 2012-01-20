require 'json'

module Model
	class YogaClass

		attr_reader :name, :teacher, :date, :dayofweek, :starthour, :endhour

		def initialize(name, teacher, date, dayofweek, starthour, endhour)
			@name 			= name.strip unless name == nil
			@teacher 		= teacher.strip unless teacher == nil
			@dayofweek	= dayofweek
			@date 			= date
			@starthour 	= starthour
			@endhour 		= endhour
		end	


		def to_hash
			{
				"name" => name,
				"teacher" => teacher,
				"dayofweek" => dayofweek,
				"date" => date,
				"starthour" => starthour,
				"endhour" => endhour	
			}
		end

		def to_json
			to_hash.to_json
		end
	end
end

module Model
	class Studio
		
		attr_accessor :classes, :name

		def initialize(name, classes=nil)
			@name = name
			@classes = classes
		end

		def to_hash
			{
				"name" => name,
				"classes" => classes.map{|c| c.to_hash}
			}
		end

		def to_json
			to_hash.to_json
		end
	end
end

module Model
	class School
		
		attr_reader :studios, :name, :homepage

		def initialize(name, homepage, studios)
			@name = name
			@homepage = homepage
			@studios = studios
		end

		def to_hash
			{
				"name" => name,
				"homepage" => homepage,
				"studios" => studios.map{|s| s.to_hash}	
			}
		end

		def to_json
			to_hash.to_json
		end	
	
	end
end
