# frozen_string_literal: true

module BAI2
  class Group
    attr_reader :header, :accounts, :trailer

    def initialize(header, accounts, trailer = nil)
      @header = header
      @accounts = accounts
      @trailer = trailer
    end

    def set_trailer(trailer)
      raise BAI2::Error, "Trailer has already been set" if @trailer

      @trailer = trailer
    end

    def total_credits
      accounts.sum(&:total_credits)
    end

    def total_debits
      accounts.sum(&:total_debits)
    end

    def net_total
      accounts.sum(&:net_total)
    end
  end
end
