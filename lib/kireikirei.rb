require "kireikirei/version"
require 'json'

class FileParseError < StandardError; end

module Kireikirei
  def self.execute(target, opts)
    if target.is_stdin
      parse_stdin(target.body, opts)
      return
    end

    if File.exists?(target.body)
      if opts["git-diff"]
        cmd = list_diff_json
        diff_arr = cmd.split(/$/).map(&:strip)
        paths = diff_arr
      else
        paths = File.directory?(target.body) ? Dir.glob("#{target.body}/**/*.json") : Dir.glob(target.body)
      end
    else
      assert_file_not_found
      exit
    end

    for path in paths
      next if is_not_json
      begin
        rewrite(path, opts)
      rescue FileParseError => e
        assert_parse_failed
        next
      end
    end
  end

  def self.rewrite(path, opts)
    file = File.read(path)
    data_hash = JSON.parse(file.force_encoding("UTF-8"))
    formatted = JSON.pretty_generate(data_hash).gsub /^$\n/, ''
    File.write(path, formatted)
  end

  def self.parse_stdin(stdin, otps)
    data_hash = JSON.parse(stdin)
    formatted = JSON.pretty_generate(data_hash).gsub /^$\n/, ''
    puts formatted
  end

  def self.is_not_json(path)
    return /.+.json/ !~ path
  end

  def self.list_diff_json
    `git status | egrep "$*.json" | sed -E "s/([^:]+: +)(.*)/\\2/"`
  end

  def self.assert_file_not_found
    puts "[Error] Could not find directory ot file."
  end

  def self.assert_parse_failed
    puts "[Error] Could not parse json correctly."
  end
end
