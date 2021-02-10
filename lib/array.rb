# frozen_string_literal: true

require 'csv'
require 'fileutils'

# Monkey patch
# https://gist.github.com/christiangenco/8acebde2025bf0891987
class  Array
  def to_csv!(filepath = 'out.csv')
    FileUtils.mkdir_p(File.dirname(filepath))
    FileUtils.rm_f(filepath)

    puts "Saving #{size} rows to #{filepath}"
    CSV.open(filepath, 'wb') do |csv|
      headers = first.keys
      csv << headers
      self.each do |hash|
        csv << hash.values_at(*headers)
      end
    end
  end
end
