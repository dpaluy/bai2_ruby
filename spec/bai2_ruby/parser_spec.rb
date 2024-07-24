# frozen_string_literal: true

require "spec_helper"

RSpec.describe BAI2::Parser do
  let(:sample_bai2_content) do
    <<~BAI2
      01,SENDER1,RECEIVER1,210628,1200,123456,80,0,2
      02,ULTRCV1,ORIG1,1,210628,1200,USD,1
      03,ACCT123,USD,DDA
      16,409,1000.00,DEPOSIT
      49,1000.00,1
      98,1000.00,1,3
      99,1000.00,1,5
    BAI2
  end

  subject(:parser) { described_class.new(sample_bai2_content) }

  describe "#parse" do
    let(:result) { parser.parse }

    it "correctly parses the file header" do
      expect(result.header).to be_a(BAI2::Structures::FileHeader)
      expect(result.header).to have_attributes(
        sender_id: "SENDER1",
        receiver_id: "RECEIVER1",
        file_creation_date: Date.new(2021, 6, 28),
        file_creation_time: Time.new(2021, 6, 28, 12, 0, 0, "+00:00"),
        file_id: "123456",
        physical_record_length: 80,
        block_size: 0,
        version_number: "2"
      )
    end

    it "correctly parses the group header" do
      expect(result.groups.first.header).to be_a(BAI2::Structures::GroupHeader)
      expect(result.groups.first.header).to have_attributes(
        ultimate_receiver_id: "ULTRCV1",
        originator_id: "ORIG1",
        group_status: "1",
        as_of_date: Date.new(2021, 6, 28),
        as_of_time: Time.new(2021, 6, 28, 12, 0, 0, "+00:00"),
        currency_code: "USD",
        as_of_date_modifier: "1"
      )
    end

    it "correctly parses the account header" do
      expect(result.groups.first.accounts.first.header).to be_a(BAI2::Structures::AccountHeader)
      expect(result.groups.first.accounts.first.header).to have_attributes(
        customer_account_number: "ACCT123",
        currency_code: "USD",
        type_code: "DDA"
      )
    end

    it "correctly parses transactions" do
      transaction = result.groups.first.accounts.first.transactions.first
      expect(transaction).to be_a(BAI2::Transaction)
      expect(transaction).to have_attributes(
        type: "409",
        amount: 1000.00,
        text: "DEPOSIT"
      )
    end

    it "correctly parses the account trailer" do
      expect(result.groups.first.accounts.first.trailer).to be_a(BAI2::Structures::AccountTrailer)
      expect(result.groups.first.accounts.first.trailer).to have_attributes(
        account_control_total: 1000.00,
        number_of_records: 1
      )
    end

    it "correctly parses the group trailer" do
      expect(result.groups.first.trailer).to be_a(BAI2::Structures::GroupTrailer)
      expect(result.groups.first.trailer).to have_attributes(
        group_control_total: 1000.00,
        number_of_accounts: 1,
        number_of_records: 3
      )
    end

    it "correctly parses the file trailer" do
      expect(result.trailer).to be_a(BAI2::Structures::FileTrailer)
      expect(result.trailer).to have_attributes(
        file_control_total: 1000.00,
        number_of_groups: 1,
        number_of_records: 5
      )
    end
  end
end
