require 'processit/version'


module ProcessIt

	autoload :EjsTemplate,             "processit/processor/ejs_template"
	autoload :JstProcessor,            "processit/processor/jst_processor"
	autoload :JsMinTemplate,           "processit/processor/jsmin_template"
	autoload :CharsetNormalizer,	   "processit/processor/charset_normalizer"
	autoload :SafetyColons,		       "processit/processor/safety_colons"
	autoload :Utils,                   "processit/utils"

	require 'processit/processors'
	require 'processit/builder'
	require 'tilt'
	require 'haml'

	Processors.instance.register_processor '.js', 'js', [Tilt::ERBTemplate, SafetyColons, JsMinTemplate]
	Processors.instance.register_processor '.jst', 'js', [Tilt::ERBTemplate, EjsTemplate]
	Processors.instance.register_processor '.haml', 'html', [Tilt::ERBTemplate, Tilt::HamlTemplate]
	Processors.instance.register_processor '.html', 'html', [Tilt::ERBTemplate]
	Processors.instance.register_processor '.scss', 'css', [Tilt::ERBTemplate, Tilt::ScssTemplate]
	Processors.instance.register_processor '.sass', 'css', [Tilt::ERBTemplate, Tilt::SassTemplate]
	Processors.instance.register_processor '.css', 'css', [Tilt::ERBTemplate, CharsetNormalizer]
	
end
