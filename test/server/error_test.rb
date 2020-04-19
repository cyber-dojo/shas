# frozen_string_literal: true
require_relative 'test_base'

class ErrorTest < TestBase

  def self.id58_prefix
    'q7E'
  end

  # - - - - - - - - - - - - - - - - -

  test 'F9r', %w(
  |any internal error
  |is a 500 error
  ) do
    externals.instance_exec {
      @env = Class.new do
        def [](_key)
          raise 'call-error'
        end
      end.new
    }
    stdout,stderr = capture_stdout_stderr {
      get '/sha'
    }
    assert status?(500), status
    assert_equal '', stderr, :stderr_is_empty
    json = JSON.parse!(stdout)
    assert_equal 'call-error', json['exception']['message']
  end

end
