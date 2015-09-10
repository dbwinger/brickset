require 'spec_helper'

describe Brickset::Client do
  let(:client) { Brickset::Client.new(api_key: 'api_key') }

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

  describe "#get_sets" do
    context 'with no options' do
      it "calls api with null required options" do
        expect(client).to receive(:call_api).with(
          :getSets,
          {
            userHash: nil,
            query: nil,
            theme: nil,
            subtheme: nil,
            setNumber: nil,
            year: nil,
            owned: nil,
            wanted: nil,
            orderBy: nil,
            pageSize: nil,
            pageNumber: nil,
            userName: nil
          }
        ) { {} }
        client.get_sets
      end
      context 'ArrayOfSets nil?' do
        it "is empty array" do
          expect(client).to receive(:call_api) { {} }
          expect(client.get_sets).to eq([])
        end
      end
      context 'ArrayOfSets has sets' do
        it "returns sets results" do
          expect(client).to receive(:call_api) { {"ArrayOfSets" => { "sets" => "test" } } }
          expect(client.get_sets).to eq("test")
        end
      end
    end
    context 'with options' do
      it "passes the options to call_api" do
        expect(client).to receive(:call_api).with(
          :getSets,
          {
            userHash: 'hash',
            query: nil,
            theme: nil,
            subtheme: nil,
            setNumber: nil,
            year: nil,
            owned: nil,
            wanted: nil,
            orderBy: nil,
            pageSize: nil,
            pageNumber: nil,
            userName: 'name'
          }
        ) { {} }
        client.get_sets(userHash: 'hash', userName: 'name')
      end
    end
  end

  describe "#get_recently_updated_sets" do
    it "calls the api with minutesAgo param" do
      expect(client).to receive(:call_api).with(:getRecentlyUpdatedSets, { minutesAgo: 2 }) { {} }
      client.get_recently_updated_sets 2
    end
    context 'ArrayOfSets nil?' do
      it "is empty array" do
        expect(client).to receive(:call_api) { {} }
        expect(client.get_recently_updated_sets 1).to eq([])
      end
    end
    context 'ArrayOfSets has sets' do
      it "returns sets results" do
        expect(client).to receive(:call_api) { {"ArrayOfSets" => { "sets" => "test" } } }
        expect(client.get_recently_updated_sets 1).to eq("test")
      end
    end
  end

  describe "#call_api" do
    let(:response) { double(code: 200, parsed_response: {}, body: '')}
    it "calls get using endpoint and method name" do
      expect(Brickset::Client).to receive(:get).with("#{client.endpoint}/test", hash_including(:query)) { response }
      client.send :call_api, :test
    end
    it "passes options and merges api key" do
      expect(Brickset::Client).to receive(:get).with("#{client.endpoint}/test", query: { option: 'test', apiKey: 'api_key'} ) { response }
      client.send :call_api, :test, { option: 'test' }
    end
    context 'response code == 200' do
      let(:response) { double(code: 200, parsed_response: { test: 'test' }, body: '')}
      it "returns parsed_response" do
        expect(Brickset::Client).to receive(:get) { response }
        expect(client.send :call_api, :test).to eq({test: 'test'})
      end
    end
    context 'response code != 200' do
      let(:response) { double(code: 400, parsed_response: {  }, body: 'error') }
      it "raises an error with body" do
        expect(Brickset::Client).to receive(:get) { response }
        expect { expect(client.send :call_api, :test) }.to raise_error('error')
      end
    end
  end
end
