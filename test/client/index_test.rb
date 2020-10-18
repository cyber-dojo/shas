# frozen_string_literal: true
require_relative 'test_base'
require 'uri'

class IndexTest < TestBase

  def self.id58_prefix
    'xRa'
  end

  # - - - - - - - - - - - - - - - - -

  test 'e5D', %w(
  |PATH /shas/index
  |shows service shas
  |with links to repo and image
  ) do
    visit('/shas/index')
    service_names = %w(
      custom-start-points exercises-start-points languages-start-points
      creator differ runner saver
    )
    service_names.sort.each do |name|
      css = '#' + "#{name}"
      text = page.find(css).text
      assert text.start_with?("#{name} #{STUBBED_SHAS[name][0...7]}"), name+':'+text
    end
  rescue Capybara::ElementNotFound
    # :nocov:
    puts page.html
    raise
    # :nocov:
  end

  private

  STUBBED_SHAS = {
    'custom-start-points'    => '5b405c69381df51ec02af3818200c8fe28ce16eb',
    'exercises-start-points' => 'b57f4f5136ab49bd6b96779855d3750b51a5a85e',
    'languages-start-points' => 'd26be0eaecc42f39b97a029f0a32383ce140eea8',
    'creator' => 'f21895840c7878027059f3d8eae71e3280653dbc',
    'differ'  => '9ab524318f83f3c6b6d70cba86f77af843121808',
    'runner'  => '65b6c849d4bb95ce92681a89ae48832a45031563',
    'saver'   => '8930f8c27061dba65c60c2216ee16dbde6389761',
  }

end
