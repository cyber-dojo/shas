# frozen_string_literal: true
require_relative 'app_base'
require_relative 'shas.rb'

class App < AppBase

  # - - - - - - - - - - - - - - - - - - - - - -
  # ctor

  def initialize(externals)
    super()
    @externals = externals
  end

  def target
    Shas.new(@externals)
  end

  probe_get(:alive?) # curl/k8s
  probe_get(:ready?) # curl/k8s
  probe_get(:sha)    # identity

  # - - - - - - - - - - - - - - - - - - - - - -

  get '/index', provides:[:html] do
    respond_to do |format|
      format.html do
        set_view_data
        erb :'index'
      end
    end
  end

  private

  def set_view_data
    @names = %w(
      custom-chooser exercises-chooser languages-chooser
      custom-start-points exercises-start-points languages-start-points
      avatars creator differ repler runner saver shas
    )
  end

end
