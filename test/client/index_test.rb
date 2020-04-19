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
      custom-chooser exercises-chooser languages-chooser
      custom-start-points exercises-start-points languages-start-points
      avatars creator differ repler runner saver web
    )
    service_names.sort.each do |name|
      text = find('#' + "#{name}").text
      assert text.start_with?("#{name} #{STUBBED_SHAS[name][0...7]}"), name+':'+text
    end
  end

  private

  STUBBED_SHAS = {
    'custom-chooser'    => 'a05c92cfedd88dd13a3635b29243bc78dbf75eae',
    'exercises-chooser' => '4e00b5f0b2f0d1b88d298b8bcebec1397401c31f',
    'languages-chooser' => 'e148939cf32380912e3fa228bed766fcd6401dc8',
    'custom-start-points'    => '5b405c69381df51ec02af3818200c8fe28ce16eb',
    'exercises-start-points' => 'b57f4f5136ab49bd6b96779855d3750b51a5a85e',
    'languages-start-points' => 'd26be0eaecc42f39b97a029f0a32383ce140eea8',
    'avatars' => '1fce37b8bf0d89a6fef5bc7354e392cbe6af9767',
    'creator' => 'f21895840c7878027059f3d8eae71e3280653dbc',
    'differ'  => '9ab524318f83f3c6b6d70cba86f77af843121808',
    'repler'  => '6a835b3ad1c9f66996cb50a6dd0ff54ec2b65c00',
    'runner'  => '65b6c849d4bb95ce92681a89ae48832a45031563',
    'saver'   => '8930f8c27061dba65c60c2216ee16dbde6389761',
    'web'     => 'd8ae9c8b5a46f61481932c7ad5b3a46f597b8114',
  }

end
