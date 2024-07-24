# frozen_string_literal: true

module BAI2
  class Parser
    def initialize(content, time_zone: "+00:00")
      @lines = content.split("\n")
      @current_group = nil
      @current_account = nil
      @time_zone = time_zone
    end

    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/MethodLength
    def parse
      file_header = parse_file_header(@lines.shift)
      file_trailer = parse_file_trailer(@lines.pop)

      groups = []

      @lines.each do |line|
        record_code = line[0, 2]
        case record_code
        when "02"
          @current_group = parse_group_header(line)
          groups << @current_group
        when "03"
          @current_account = parse_account_header(line)
          @current_group.accounts << @current_account
        when "16"
          transaction = parse_transaction(line)
          @current_account.transactions << transaction
        when "49"
          parse_account_trailer(line)
        when "98"
          parse_group_trailer(line)
        else
          raise BAI2::Error, "Unknown record code: #{record_code}"
        end
      end

      BAI2::File.new(file_header, groups, file_trailer)
    end
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/MethodLength

    private

    def parse_file_header(line)
      fields = line.split(",")
      date = parse_date(fields[3])
      BAI2::Structures::FileHeader.new(
        sender_id: fields[1],
        receiver_id: fields[2],
        file_creation_date: date,
        file_creation_time: parse_time(fields[4], date),
        file_id: fields[5],
        physical_record_length: fields[6].to_i,
        block_size: fields[7].to_i,
        version_number: fields[8]
      )
    end

    def parse_file_trailer(line)
      fields = line.split(",")
      BAI2::Structures::FileTrailer.new(
        file_control_total: fields[1].to_f,
        number_of_groups: fields[2].to_i,
        number_of_records: fields[3].to_i
      )
    end

    def parse_group_header(line)
      fields = line.split(",")
      date = parse_date(fields[4])
      header = BAI2::Structures::GroupHeader.new(
        ultimate_receiver_id: fields[1],
        originator_id: fields[2],
        group_status: fields[3],
        as_of_date: date,
        as_of_time: parse_time(fields[5], date),
        currency_code: fields[6],
        as_of_date_modifier: fields[7]
      )
      BAI2::Group.new(header, [])
    end

    def parse_account_header(line)
      fields = line.split(",")
      header = BAI2::Structures::AccountHeader.new(
        customer_account_number: fields[1],
        currency_code: fields[2],
        type_code: fields[3]
      )
      BAI2::Account.new(header, [])
    end

    def parse_transaction(line)
      fields = line.split(",")
      BAI2::Transaction.new(fields[1], fields[2].to_f, fields[3])
    end

    def parse_account_trailer(line)
      fields = line.split(",")
      trailer = BAI2::Structures::AccountTrailer.new(
        account_control_total: fields[1].to_f,
        number_of_records: fields[2].to_i
      )
      @current_account.set_trailer(trailer)
    end

    def parse_group_trailer(line)
      fields = line.split(",")
      trailer = BAI2::Structures::GroupTrailer.new(
        group_control_total: fields[1].to_f,
        number_of_accounts: fields[2].to_i,
        number_of_records: fields[3].to_i
      )
      @current_group.set_trailer(trailer)
    end

    def parse_date(date_string)
      Date.strptime(date_string, "%y%m%d")
    end

    def parse_time(time_string, date)
      hours = time_string[0, 2].to_i
      minutes = time_string[2, 2].to_i
      Time.new(date.year, date.month, date.day, hours, minutes, 0, @time_zone)
    end
  end
end
