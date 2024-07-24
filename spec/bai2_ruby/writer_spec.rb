# frozen_string_literal: true

require "spec_helper"

RSpec.describe BAI2::Writer do
  let(:file_header) do
    BAI2::Structures::FileHeader.new(
      sender_id: "SENDER1",
      receiver_id: "RECEIVER1",
      file_creation_date: Date.new(2021, 6, 28),
      file_creation_time: Time.new(2021, 6, 28, 12, 0, 0),
      file_id: "123456",
      physical_record_length: 80,
      block_size: 0,
      version_number: "2"
    )
  end

  let(:group_header) do
    BAI2::Structures::GroupHeader.new(
      ultimate_receiver_id: "ULTRCV1",
      originator_id: "ORIG1",
      group_status: "1",
      as_of_date: Date.new(2021, 6, 28),
      as_of_time: Time.new(2021, 6, 28, 12, 0, 0),
      currency_code: "USD",
      as_of_date_modifier: "1"
    )
  end

  let(:account_header) do
    BAI2::Structures::AccountHeader.new(
      customer_account_number: "ACCT123",
      currency_code: "USD",
      type_code: "DDA"
    )
  end

  let(:transaction) do
    BAI2::Transaction.new("409", 1000.00, "DEPOSIT")
  end

  let(:account_trailer) do
    BAI2::Structures::AccountTrailer.new(
      account_control_total: 1000.00,
      number_of_records: 1
    )
  end

  let(:group_trailer) do
    BAI2::Structures::GroupTrailer.new(
      group_control_total: 1000.00,
      number_of_accounts: 1,
      number_of_records: 3
    )
  end

  let(:file_trailer) do
    BAI2::Structures::FileTrailer.new(
      file_control_total: 1000.00,
      number_of_groups: 1,
      number_of_records: 5
    )
  end

  let(:account) { BAI2::Account.new(account_header, [transaction], account_trailer) }
  let(:group) { BAI2::Group.new(group_header, [account], group_trailer) }
  let(:file) { BAI2::File.new(file_header, [group], file_trailer) }

  subject(:writer) { described_class.new(file) }

  describe "#generate" do
    let(:result) { writer.generate }

    it "generates a valid BAI2 file content" do
      expected_content = [
        "01,SENDER1,RECEIVER1,210628,1200,123456,80,0,2",
        "02,ULTRCV1,ORIG1,1,210628,1200,USD,1",
        "03,ACCT123,USD,DDA",
        "16,409,1000.00,DEPOSIT",
        "49,1000.00,1",
        "98,1000.00,1,3",
        "99,1000.00,1,5"
      ].join("\n")

      expect(result).to eq(expected_content)
    end
  end
end
