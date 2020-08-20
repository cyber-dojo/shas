# frozen_string_literal: true
require_relative 'test_base'

class IndexTest < TestBase

  def self.id58_prefix
    '304'
  end

  # - - - - - - - - - - - - - - - - -

  test 'q5e',
  %w( index page has entry for each service ) do
    get '/index'
    assert status?(200), status
    html = last_response.body
    SERVICE_NAMES.sort.each do |name|
      assert html =~ id_for(name), name+':'+html
    end
  end

  private

  def id_for(name)
    name = Regexp.quote(escape_html(name))
    /id="#{name}">/
  end

  SERVICE_NAMES = %w(
    custom-start-points exercises-start-points languages-start-points
    avatars creator differ runner saver shas
  )

end
