require 'donaghy/adapters/bunny_adapter'

module Donaghy
  module BunnyAdapter
    describe MessageQueue do

      describe "receiving" do
        subject { MessageQueue.new(name: 'bob', options: {auto_delete: true}) }

        let(:event) { Event.new(payload: {value: 'hi'}) }

        it "receives" do
          subject.publish(event)
          expect(subject.receive.payload).to eq(event)
        end

      end

    end

  end
end