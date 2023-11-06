# frozen_string_literal: true

class Shas

  def initialize(externals)
    @externals = externals
  end

  def alive?
    true
  end

  def ready?
    true
  end

  def sha
    @externals.env['SHA']
  end

end
