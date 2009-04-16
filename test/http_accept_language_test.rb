$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'http_accept_language'
require 'test/unit'
require 'FileUtils'

RAILS_ROOT = "#{File.dirname(__FILE__)}"

class MockedCgiRequest
  include HttpAcceptLanguage

  def env
    @env ||= {'HTTP_ACCEPT_LANGUAGE' => 'en-us,en-gb;q=0.8,en;q=0.6'}
  end
end

class HttpAcceptLanguageTest < Test::Unit::TestCase
  def test_should_return_empty_array
    request.env['HTTP_ACCEPT_LANGUAGE'] = nil
    assert_equal [], request.user_preferred_languages
  end

  def test_should_properly_split
    assert_equal %w{en-US en-GB en}, request.user_preferred_languages
  end

  def test_should_ignore_jambled_header
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'odkhjf89fioma098jq .,.,'
    assert_equal [], request.user_preferred_languages
  end

  def test_should_find_first_available_language
    assert_equal 'en-GB', request.preferred_language_from(%w{en en-GB})
  end

  def test_should_find_first_compatible_language
    assert_equal 'en-hk', request.compatible_language_from(%w{en-hk})
    assert_equal 'en', request.compatible_language_from(%w{en})
  end

  def test_should_find_first_compatible_from_user_preferred
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'en-us,de-de'
    assert_equal 'en', request.compatible_language_from(%w{de en})
  end

  def create_locale_file files
    name = "#{RAILS_ROOT}/lib/locale"
    FileUtils.mkdir_p  name
    files.each do |file|
      File.new name + "/#{file}.yml", 'w+'
    end
  end

  def test_should_load_avaliable_locale_from_locale_folder
    self.create_locale_file 'en-US'
    assert_equal "en-US", request.suggest_language
  end

  def test_should_load_avaliable_locale_from_locale_folder_when_given_locale_does_not_exist
    self.create_locale_file 'en-US'
    assert_equal "en-US", request.suggest_language
  end

  def test_should_load_avaliable_locale_from_locale_folder_when_given_locale_exists
    request.env['HTTP_ACCEPT_LANGUAGE'] = 'de-de,zh-CN'
    self.create_locale_file 'en-US'
    self.create_locale_file 'zh-CN'
    assert_equal "zh-CN", request.suggest_language

  end


  private

  def request
    @request ||= MockedCgiRequest.new
  end

 


end

