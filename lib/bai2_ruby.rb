# frozen_string_literal: true

require "date"
require "time"
require_relative "bai2_ruby/version"
require_relative "bai2_ruby/structures/file_header"
require_relative "bai2_ruby/structures/file_trailer"
require_relative "bai2_ruby/structures/group_header"
require_relative "bai2_ruby/structures/group_trailer"
require_relative "bai2_ruby/structures/account_header"
require_relative "bai2_ruby/structures/account_trailer"
require_relative "bai2_ruby/structures/transaction"
require_relative "bai2_ruby/parser"
require_relative "bai2_ruby/writer"
require_relative "bai2_ruby/file"
require_relative "bai2_ruby/group"
require_relative "bai2_ruby/account"
require_relative "bai2_ruby/transaction"

module BAI2
  class Error < StandardError; end
  # Your code goes here...
end
