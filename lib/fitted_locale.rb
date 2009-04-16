class I18n
  def self.fitted_locale request
    dir = Dir.new "#{RAILS_ROOT}/lib/locale"

    supported_language = []

    dir.each do |file|
      if file != '.' && file != '..'
        supported_language << file.chomp('.yml').downcase.gsub(/-[a-z]+$/i) { |x| x.upcase }
      end
    end

    all_languages = request.compatible_language_from supported_language
    return all_languages ? all_languages : 'en';
  end
end


