require 'spec_helper'

describe 'configuration' do
  after { Brickset.reset }

  describe '.configure' do
    Brickset::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do 
        Brickset.configure do |config|
          config.send("#{key}=", key)
          expect(Brickset.send(key)).to eq(key)
        end
      end
    end
  end

  Brickset::Configuration::VALID_CONFIG_KEYS.each do |key|
    describe ".#{key}" do
      it 'should return the default value' do
        expect(Brickset.send(key)).to eq(Brickset::Configuration.const_get("DEFAULT_#{key.upcase}"))
      end
    end
  end

end