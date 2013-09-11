require 'spec_helper'

describe Fluent::HatoOutput do
  let(:conf) {
    %[
      api_key        test_key
      host           localhost
      message_keys   foo,bar, baz ,qux
      message_format [test] %s %s %s %s
    ]
  }

  describe '#configure' do
    context "success" do
      let(:driver) { Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(conf) }
      subject {
        driver.instance
      }

      it {
        expect(subject).to be_an_instance_of described_class
        expect(subject.api_key).to be == 'test_key'
      }
    end

    context "failure" do
      context 'api_key not set' do
        it {
          expect {
            Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(
              %[
                host           localhost
                message_keys   foo,bar, baz ,qux
                message_format [test] %s %s %s %s
              ]
            )
          }.to raise_error(Fluent::ConfigError)
        }
      end

      context 'host not set' do
        it {
          expect {
            Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(
              %[
                api_key        test_key
                message_keys   foo,bar, baz ,qux
                message_format [test] %s %s %s %s
              ]
            )
          }.to raise_error(Fluent::ConfigError)
        }
      end
    end
  end

  describe "#send_message" do
    let(:driver) {
      Fluent::Test::OutputTestDriver.new(described_class, 'test').configure(conf)
    }
    subject {
      driver.instance
    }
    before {
      $log.reset
    }

    context 'success' do
      before {
        allow(subject).to receive(:send_request).and_return(
          Net::HTTPSuccess.new('1.1', '200', 'success')
        )

        subject.send(:send_message, 'test', 'test message')
      }

      it {
        expect($log.message).to be_nil
      }
    end

    context 'failure' do
      context 'network error' do
        before {
          allow(subject).to receive(:send_request).and_raise(Timeout::Error.new('timeout'))
          subject.send(:send_message, 'test', 'test message')
        }

        it {
          expect($log.message).to be =~ /timeout/
        }
      end

      context 'http error' do
        before {
          allow(subject).to receive(:send_request).and_return(
            Net::HTTPClientError.new('1.1', '403', 'forbidden')
          )
          subject.send(:send_message, 'test', 'test message')
        }

        it {
          expect($log.message).to be =~ /forbidden/
        }
      end
    end
  end
end

