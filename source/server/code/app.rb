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

  probe_get(:alive?)
  probe_get(:ready?)
  probe_get(:sha)

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
      custom-start-points exercises-start-points languages-start-points
      avatars creator differ model runner saver shas web
    )
  end

end
