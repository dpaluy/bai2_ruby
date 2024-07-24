# frozen_string_literal: true

require "spec_helper"

RSpec.describe BAI2::File do
  let(:header) { instance_double("BAI2::FileHeader") }
  let(:group) { instance_double("BAI2::Group") }
  let(:trailer) { instance_double("BAI2::FileTrailer") }

  subject(:file) { described_class.new(header, [group], trailer) }

  describe "#initialize" do
    it "sets the header" do
      expect(file.header).to eq(header)
    end

    it "sets the groups" do
      expect(file.groups).to eq([group])
    end

    it "sets the trailer" do
      expect(file.trailer).to eq(trailer)
    end
  end
end
