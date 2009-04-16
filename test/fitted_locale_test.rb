$:.unshift(File.dirname(__FILE__) + '/../lib')
RAILS_ROOT = "#{File.dirname(__FILE__)}"
class I18n
end

require 'http_accept_language'
require 'fitted_locale'
require 'test/unit'
require 'FileUtils'
require  File.dirname(__FILE__) + '/../init.rb'
   

class MockedCgiRequest
  include HttpAcceptLanguage

  def env
    @env ||= {'HTTP_ACCEPT_LANGUAGE' => 'en-us,en-gb;q=0.8,en;q=0.6'}
  end
end

class FittedLocleTest < Test::Unit::TestCase

  def teardown
    FileUtils.rmtree "#{RAILS_ROOT}/lib"
    request.env['HTTP_ACCEPT_LANGUAGE'] = ''
  end

  def test_should_load_en_locale_as_default_when_no_match_found
    create_locale_file 'zh-CN'

    assert_equal "en", I18n.fitted_locale(request)
  end

  def test_should_load_avaliable_locale_from_locale_folder_when_given_locale_exists
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'de-de,zh-CN'
    create_locale_file 'en-US', 'zh-CN'

    assert_equal "zh-CN", I18n.fitted_locale(request)
  end

  def test_should_load_first_avaliable_locale_from_when_multiple_matches_found
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-US,zh-CN'
    create_locale_file 'zh-CN', 'en-US'

    assert_equal "en-US", I18n.fitted_locale(request)
  end

  private

  def request
    @request ||= MockedCgiRequest.new
  end

  def create_locale_file *files
      name = "#{RAILS_ROOT}/lib/locale"
      FileUtils.mkdir_p  name
      files.each do |file|
        File.new name + "/#{file}.yml", 'w+'
      end
  end
end

