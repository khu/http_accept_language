def module_defined? name
    module_defined = false
    constant = Object
    name.split('::').each do |splited|
      if constant.const_defined? splited
        constant = constant.const_get splited
        module_defined = true
      else
        module_defined = false
      end
    end
    module_defined
end

if module_defined?('ActionController::Request')
  ActionController::Request.send :include, HttpAcceptLanguage
elsif module_defined?('ActionController::AbstractRequest')
  ActionController::AbstractRequest.send :include, HttpAcceptLanguage
elsif module_defined?('ActionController::CgiRequest')
  ActionController::CgiRequest.send :include, HttpAcceptLanguage
end

require 'fitted_locale'
