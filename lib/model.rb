
module Model
	class YogaClass

		attr_reader :name, :teacher, :date, :starthour, :endhour

		def initialize(name, teacher, date, starthour, endhour)
			@name 			= name
			@teacher 		= teacher
			@date 			= date
			@starthour 	= starthour
			@endhour 		= endhour
		end	
	
	end
end

module Model
	class Studio
		
		attr_reader :classes, :name

		def initialize(name, classes=nil)
			@name = name
			@classes = classes
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

	end
end
