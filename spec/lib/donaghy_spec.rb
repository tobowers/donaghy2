require 'donaghy'

describe Donaghy do

  describe 'configuration' do
    subject { Donaghy.configuration }
    
    [:name, :pwd, :concurrency].each do |key|
      it { is_expected.to include(key) }
    end
  end

end