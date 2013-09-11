require 'fluent/test'
require 'fluent/plugin/out_hato'

RSpec.configure do |config|
end

unless ENV.has_key?('VERBOSE')
  nulllogger = Object.new
  nulllogger.instance_eval {|obj|
    def message
      @message
    end

    def reset
      @message = nil
    end

    def method_missing(method, *args)
      @message = args.first
    end
  }
  $log = nulllogger
end

