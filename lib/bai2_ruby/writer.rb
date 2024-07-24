# frozen_string_literal: true

module BAI2
  class Writer
    def initialize(file)
      @file = file
    end

    # rubocop:disable Metrics/AbcSize
    def generate
      content = []
      content << generate_file_header(@file.header)

      @file.groups.each do |group|
        content << generate_group_header(group.header)

        group.accounts.each do |account|
          content << generate_account_header(account.header)

          account.transactions.each do |transaction|
            content << generate_transaction(transaction)
          end

          content << generate_account_trailer(account.trailer)
        end

        content << generate_group_trailer(group.trailer)
      end

      content << generate_file_trailer(@file.trailer)
      content.join("\n")
    end
    # rubocop:enable Metrics/AbcSize

    private

    def generate_file_header(header)
      "01,#{header.sender_id},#{header.receiver_id},#{format_date(header.file_creation_date)},#{format_time(header.file_creation_time)},#{header.file_id},#{header.physical_record_length},#{header.block_size},#{header.version_number}"
    end

    def generate_group_header(header)
      "02,#{header.ultimate_receiver_id},#{header.originator_id},#{header.group_status},#{format_date(header.as_of_date)},#{format_time(header.as_of_time)},#{header.currency_code},#{header.as_of_date_modifier}"
    end

    def generate_account_header(header)
      "03,#{header.customer_account_number},#{header.currency_code},#{header.type_code}"
    end

    def generate_transaction(transaction)
      "16,#{transaction.type},#{format_amount(transaction.amount)},#{transaction.text}"
    end

    def generate_account_trailer(trailer)
      "49,#{format_amount(trailer.account_control_total)},#{trailer.number_of_records}"
    end

    def generate_group_trailer(trailer)
      "98,#{format_amount(trailer.group_control_total)},#{trailer.number_of_accounts},#{trailer.number_of_records}"
    end

    def generate_file_trailer(trailer)
      "99,#{format_amount(trailer.file_control_total)},#{trailer.number_of_groups},#{trailer.number_of_records}"
    end

    def format_date(date)
      date.strftime("%y%m%d")
    end

    def format_time(time)
      time.strftime("%H%M")
    end

    def format_amount(amount)
      format("%.2f", amount)
    end
  end
end
