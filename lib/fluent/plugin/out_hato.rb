require 'uri'
require 'net/http'

class Fluent::HatoOutput < Fluent::Output
  Fluent::Plugin.register_output('hato', self)

  include Fluent::HandleTagNameMixin

  config_param :api_key,        :string
  config_param :scheme,         :string,  :default => 'http'
  config_param :host,           :string
  config_param :port,           :integer, :default => 9699
  config_param :message_keys,   :string,  :default => ''
  config_param :message_format, :string,  :default => ''

  def configure(conf)
    super

    if @api_key.nil?
      raise Fluent::ConfigError(
        '[out_hato] missing mandatory parameter: `api_key`'
      )
    end

    if @host.nil?
      raise Fluent::ConfigError(
        '[out_hato] missing mandatory parameter: `host`'
      )
    end

    @api_endpoint = '%s://%s:%s/notify' % [
      @scheme,
      @host,
      @port,
    ]
  end

  def emit(tag, es, chain)
    es.each do |time, record|
      message = message_format % message_keys.split(/\s*,\s*/).map do |key|
        record[key].to_s
      end
      send_message(tag, message)
    end
  end

  private

  def send_message(tag, message)
    begin
      res = send_request(tag, message)
      res.value
    rescue => e
      $log.warn("[out_hato] failed to send a message tagged with #{tag} to #{scheme}://#{@host}:#{port} for the reason '#{e.message}'")
    end
  end

  def send_request(tag, message)
    http = Net::HTTP.new(URI(@api_endpoint).host, URI(@api_endpoint).port)
    req  = Net::HTTP::Post.new(URI(@api_endpoint).path)

    req.form_data = {
      'tag'     => tag,
      'message' => message,
      'api_key' => @api_key,
    }

    http.request(req)
  end
end

