module ProcessIt

	class Processors

		def initialize
			@processors = {}
			@null_extention = {"output_ext" => nil, "klasses" => []}
		end
   
		@@instance = Processors.new
		
		def self.instance
			return @@instance
		end

		# Returns a `Hash` of `Engine`s registered on the `Environment`.
		# If an `ext` argument is supplied, the `Engine` associated with
		# that extension will be returned.
		#
		#     processors
		#     # => {".coffee" => CoffeeScriptTemplate, ".sass" => SassTemplate, ...}

		def processor(ext = nil)
		  if ext
			ext = ProcessIt::Utils.normalize_extension(ext)
			processor = @processors[ext]
			if (processor)
				return processor
			end
		  end

		  return @null_extention
		end

		# Returns an `Array` of processor extension `String`s.
		#
		#     environment.engine_extensions
		#     # => ['.coffee', '.sass', ...]
		def process_extensions
		  @processors.keys
		end

		# Registers a new Engine `klass` for `ext`. If the `ext` already
		# has an engine registered, it will be overridden.
		#
		#     environment.register_engine '.coffee', CoffeeScriptTemplate
		#
		def register_processor(ext, output_ext, klasses = [])
		  ext = ProcessIt::Utils.normalize_extension(ext)
		  @processors[ext] = {"output_ext" => output_ext, "klasses" => klasses}
		end

		private
		  private_class_method :new
	end
end
