# frozen_string_literal: true

class Shas

  def initialize(externals)
    @externals = externals
  end

  def alive?
    p "alive? => true"
    true
  end

  def ready?
    p "ready => true"
    true
  end

  def sha
    @externals.env['SHA']
  end

end
