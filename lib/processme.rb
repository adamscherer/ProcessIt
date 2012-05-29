require 'processme/version'


module ProcessMe

	autoload :EjsTemplate,             "processme/processor/ejs_template"
	autoload :JstProcessor,            "processme/processor/jst_processor"
	autoload :JsMinTemplate,           "processme/processor/jsmin_template"
	autoload :CharsetNormalizer,	   "processme/processor/charset_normalizer"
	autoload :SafetyColons,		       "processme/processor/safety_colons"
	autoload :Utils,                   "processme/utils"

	require 'processme/processors'
	require 'processme/builder'

	Processors.instance.register_processor '.js', 'js', [Tilt::ERBTemplate, SafetyColons, JsMinTemplate]
	Processors.instance.register_processor '.jst', 'js', [Tilt::ERBTemplate, EjsTemplate]
	Processors.instance.register_processor '.haml', 'html', [Tilt::ERBTemplate, Tilt::HamlTemplate]
	Processors.instance.register_processor '.scss', 'css', [Tilt::ERBTemplate, Tilt::ScssTemplate]
	Processors.instance.register_processor '.sass', 'css', [Tilt::ERBTemplate, Tilt::SassTemplate]
	Processors.instance.register_processor '.css', 'css', [Tilt::ERBTemplate, CharsetNormalizer]
	
end
