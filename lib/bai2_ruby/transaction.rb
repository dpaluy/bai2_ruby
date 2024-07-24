# frozen_string_literal: true

module BAI2
  class Transaction
    attr_reader :type, :amount, :text, :funds_type

    CREDIT_CODES = %w[105 106 107 108 109 110 115 116 118 201 202 206 207 210 221 222 223 224 225 226 227 230 231 263
                      285 415 416 420 490 600 601 616 618 621 623 632 633 634 664 701 702 703 705 706 707 708 709 710
                      711 712 713 714 715 716 717 805 902].freeze
    DEBIT_CODES = %w[175 176 177 178 179 180 181 185 186 187 188 277 278 405 406 407 408 410 412 413 414 425 465 469
                     470 471 472 477 481 482 484 485 486 487 489 500 501 502 505 506 507 508 509 510 512 513 514 516
                     518 519 522 532 535 536 554 555 556 557 558 560 561 564 566 570 702 703 709 715 720 890].freeze

    def initialize(type, amount, text, funds_type = nil)
      @type = type
      @amount = amount.to_f
      @text = text
      @funds_type = funds_type
    end

    def debit?
      DEBIT_CODES.include?(@type)
    end

    def credit?
      CREDIT_CODES.include?(@type)
    end

    def signed_amount
      debit? ? -@amount : @amount
    end

    # rubocop:disable Style/FormatString
    def to_s
      "#{credit? ? "Credit" : "Debit"} transaction (#{@type}): $#{"%.2f" % @amount.abs} - #{@text}"
    end
    # rubocop:enable Style/FormatString

    def as_json
      {
        type: @type,
        amount: @amount,
        signed_amount: signed_amount,
        text: @text,
        is_debit: debit?,
        is_credit: credit?
      }
    end
  end
end
