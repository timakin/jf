require "kireikirei/version"
require 'json'

module Kireikirei
  def execute(opt)
    if opt == '-a'
      paths = Dir.glob("./**/*.json")
    else
      Dir.chdir("./")
      cmd = `git diff --name-only`
      diff_arr = cmd.split(/$/).map(&:strip)
      paths = diff_arr
    end

    for path in paths
      begin
        file = File.read(path)
        data_hash = JSON.parse(file)
        formatted = JSON.pretty_generate(data_hash).gsub /^$\n/, ''
        File.write(path, formatted)
      rescue
        next
      end
    end
  end

  module_function :execute
end
