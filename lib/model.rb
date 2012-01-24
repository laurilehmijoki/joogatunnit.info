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
			@name = name.strip
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
		
		attr_reader :studios, :name, :homepage, :logo_url, :id

		def initialize(name, homepage, studios, logo_url, id)
			@name = name.strip
			@homepage = homepage
			@studios = studios
      @logo_url = logo_url
      @id = id
		end

		def to_hash
			{
				"name" => name,
        "id" => id,
        "logo_url" => logo_url,
				"homepage" => homepage,
				"studios" => studios.map{|s| s.to_hash}	
			}
		end

		def to_json
			to_hash.to_json
		end	
	
	end
end
