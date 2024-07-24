# BAI2 Ruby

BAI2 - Bank Administration Institute 2 file format

BAI2 Ruby is a gem that provides a parser and writer for the BAI2 (Bank Administration Institute) file format. This gem allows you to easily read and write BAI2 files in your Ruby applications.

## Features

- Parse BAI2 files into Ruby objects
- Generate BAI2 files from Ruby objects
- Supports all standard BAI2 record types
- Handles date and time parsing with configurable time zones

## Installation

`gem "bai2_ruby"`

## Usage

### Parsing a BAI2 file

```ruby
require 'bai2_ruby'

# Read the content of a BAI2 file
bai2_content = File.read('path/to/your/bai2_file.bai')

# Create a parser instance
parser = BAI2::Parser.new(bai2_content)

# Parse the content
bai2_file = parser.parse

# Access the parsed data
puts bai2_file.header.sender_id
puts bai2_file.header.file_creation_date

bai2_file.groups.each do |group|
  puts group.header.originator_id
  group.accounts.each do |account|
    puts account.header.customer_account_number
    account.transactions.each do |transaction|
      puts "#{transaction.type}: #{transaction.amount}"
    end
  end
end
```

### Writing a BAI2 file

```ruby
require 'bai2_ruby'

# Create BAI2 structures
file_header = BAI2::Structures::FileHeader.new(
  sender_id: 'SENDER1',
  receiver_id: 'RECEIVER1',
  file_creation_date: Date.today,
  file_creation_time: Time.now,
  file_id: '123456',
  physical_record_length: 80,
  block_size: 0,
  version_number: '2'
)

# ... Create other structures (groups, accounts, transactions) ...

# Create a BAI2::File object
bai2_file = BAI2::File.new(file_header, groups, file_trailer)

# Create a writer instance
writer = BAI2::Writer.new(bai2_file)

# Generate BAI2 content
bai2_content = writer.generate

# Write to a file
File.write('path/to/output.bai', bai2_content)
```

### Configuration

By default, the parser uses UTC for time parsing. You can specify a different time zone when creating a parser:

```ruby
parser = BAI2::Parser.new(bai2_content, time_zone: "-05:00")
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.
To install this gem onto your local machine, run `bundle exec rake install`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dpaluy/bai2_ruby.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
