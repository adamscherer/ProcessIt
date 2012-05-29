require 'tilt'

module ProcessIt
  # Tilt engine class for the JSMin compiler. Depends on the `jsmin` gem.
  #
  # For more infomation see:
  #
  # https://rubygems.org/gems/jsmin
  #
  class JsMinTemplate < Tilt::Template
    # Check to see if JSMin is loaded
    def self.engine_initialized?
      defined? ::JSMin
    end

    # Autoload jsmin library. If the library isn't loaded, Tilt will produce
    # a thread safetly warning. If you intend to use `.js` files, you
    # should explicitly require it.
    def initialize_engine
      require_template_library 'jsmin'
    end

    def prepare
		@output = nil
    end

    # Compile template data with JSMin compiler.
    def evaluate(scope, locals, &block)
      @output ||= ::JSMin.minify(data)
    end
  end
end
