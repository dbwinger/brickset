require 'spec_helper'

describe Brickset::Client do

  before do
    @keys = Brickset::Configuration::VALID_CONFIG_KEYS
  end

  describe 'with module configuration' do
    before do
      Brickset.configure do |config|
        @keys.each do |key|
          config.send("#{key}=", key)
        end
      end
    end

    after do
      Brickset.reset
    end

    it "should inherit module configuration" do
      api = Brickset::Client.new
      @keys.each do |key|
        expect(api.send(key)).to eq(key)
      end
    end

    describe 'with class configuration' do
      before do
        @config = {
          :api_key    => 'ak',
          :endpoint   => 'ep',
          :user_agent => 'ua',
          :method     => 'hm',
        }
      end

      it 'should override module configuration' do
        api = Brickset::Client.new(@config)
        @keys.each do |key|
          expect(api.send(key)).to eq(@config[key])
        end
      end

      it 'should override module configuration after' do
        api = Brickset::Client.new

        @config.each do |key, value|
          api.send("#{key}=", value)
        end

        @keys.each do |key|
          expect(api.send("#{key}")).to eq(@config[key])
        end
      end
    end
  end
end