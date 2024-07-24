# frozen_string_literal: true

module BAI2
  module Structures
    class GroupHeader
      attr_reader :ultimate_receiver_id, :originator_id, :group_status, :as_of_date,
                  :as_of_time, :currency_code, :as_of_date_modifier

      def initialize(ultimate_receiver_id:, originator_id:, group_status:, as_of_date:,
                     as_of_time:, currency_code:, as_of_date_modifier:)
        @ultimate_receiver_id = ultimate_receiver_id
        @originator_id = originator_id
        @group_status = group_status
        @as_of_date = as_of_date
        @as_of_time = as_of_time
        @currency_code = currency_code
        @as_of_date_modifier = as_of_date_modifier
      end
    end
  end
end
