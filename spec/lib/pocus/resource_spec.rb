require 'spec_helper'

RSpec.describe Pocus::Resource do
  let(:klass) { Klass = Class.new(Pocus::Resource) }
  subject { klass.new('attr' => 'val') }

  it 'supports deserialization even if never instantiated' do
    serial_data = Marshal.dump(subject)
    expect(Marshal.load(serial_data).attr).to eq 'val'

    Object.send(:remove_const, 'Klass')
    Klass = Class.new(Pocus::Resource)
    expect(Marshal.load(serial_data).attr).to eq 'val'
  end
end
