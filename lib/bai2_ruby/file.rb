# frozen_string_literal: true

module BAI2
  class File
    attr_reader :header, :groups, :trailer

    def initialize(header, groups, trailer)
      @header = header
      @groups = groups
      @trailer = trailer
    end

    def total_credits
      groups.sum(&:total_credits)
    end

    def total_debits
      groups.sum(&:total_debits)
    end

    def net_total
      groups.sum(&:net_total)
    end

    def all_transactions
      groups.flat_map { |group| group.accounts.flat_map(&:transactions) }
    end
  end
end
