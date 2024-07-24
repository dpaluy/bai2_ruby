# frozen_string_literal: true

module BAI2
  class Account
    attr_reader :header, :transactions, :trailer

    def initialize(header, transactions, trailer = nil)
      @header = header
      @transactions = transactions
      @trailer = trailer
    end

    def set_trailer(trailer)
      raise BAI2::Error, "Trailer has already been set" if @trailer

      @trailer = trailer
    end

    def total_credits
      transactions.select(&:credit?).sum(&:amount)
    end

    def total_debits
      transactions.select(&:debit?).sum(&:amount)
    end

    def net_total
      transactions.sum(&:signed_amount)
    end
  end
end
