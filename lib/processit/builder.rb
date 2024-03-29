require 'processit/utils'
require 'processit/processors'
require 'fileutils'

module ProcessIt
	class Builder

		def initialize(root = ".")
			@base_dir = Dir.pwd
			@src_dir = File.join(@base_dir, "src")
			@site_dir = File.join(@base_dir, "site")
			@html_src_dir = File.join(@src_dir, "pages")
			
			@config = YAML.load_file("#{@src_dir}/data/data.yml")
		end

		def watch
			puts ">>> ProcessMe is watching for changes. Press Ctrl-C to Stop."

			require 'fssm'
			begin
				FSSM.monitor do |monitor|
					monitor.path @src_dir do |path|
						path.create do |base, relative|
							build
						end
						
						path.update do |base, relative|
							build
						end

						path.delete do |base, relative|
							build
						end
					end
				end
			end
		end
		
		def build
			puts ">>> ProcessIt is building your site." 
			Dir["#{@src_dir}/**/*"].each do |path|
				next if File.basename(path) =~ /^\_/  or File.directory?(path) # skip partials and directories

				save_page(path, evaluate(path))
			end
		end

		def evaluate(path, options = {})
			ext = File.extname(path)
			path = File.absolute_path(path, @src_dir)
			result = ProcessIt::Utils.read_unicode(path)
			Processors.instance.processor(ext)["klasses"].each do |processor|
				begin
				  template = processor.new(path) { result }
				  result = template.render(self, @config)
				rescue Exception => e
				  puts e
				  raise
				end
			end

			result
		end
		
		def cms() 
		
		end

		def copy_file(from, to)
			FileUtils.cp(from, to)
		end

		def save_page(path, content)
			ext = File.extname(path)
			file_dir, file_name = File.split(path)
			relative_name = path.sub(/^#{@src_dir}/, '')
			relative_name.chomp!(ext)
			output_ext = Processors.instance.processor(ext)["output_ext"]
			if (output_ext)
				generate_site_file(relative_name, output_ext, content)
			end
		end

		def generate_site_file(relative_name, extension, content)
			
			path = File.join(@site_dir, "#{relative_name}.#{extension}")
			FileUtils.mkdir_p(File.dirname(path))
			File.open(path, 'w+') do |f|
			  f << content
			end

			puts "created #{path}"
		end

		# Returns a raw template name from a source file path:
		# source_template_from_path("/path/to/site/src/stylesheets/application.sass")  ->  "application"
		def source_template_from_path(path)
			file_dir, file_name = File.split(path)
			file_name.chomp!(File.extname(file_name))
			[ file_dir, file_name, File.extname(path) ]
		end

	end
end