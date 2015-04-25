require 'donaghy/adapters/bunny_adapter'

module Donaghy
  module BunnyAdapter
    describe MessageQueue do

      describe "receiving" do
        subject { MessageQueue.new(name: 'bob', options: {auto_delete: true}) }

        it "receives" do
          BunnyAdapter.publish('bob', 'hi')
          expect(subject.receive[:payload]).to eq('hi')
        end

      end

    end

  end
end