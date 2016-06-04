require "kireikirei/version"
require 'json'



module Kireikirei
  def execute(target, opts)
    if File.exists?(target)
      if opts["git-diff"]
        cmd = `git status | egrep "$*.json" | sed -E "s/([^:]+: +)(.*)/\\2/"`
        diff_arr = cmd.split(/$/).map(&:strip)
        paths = diff_arr
      else
        paths = File.directory?(target) ? Dir.glob("#{target}/**/*.json") : Dir.glob(target)
      end
    else
      puts "[Error] Could not find directory ot file."
      exit
    end

    for path in paths
        begin
            file = File.read(path)
            data_hash = JSON.parse(file.force_encoding("UTF-8"))
            formatted = JSON.pretty_generate(data_hash).gsub /^$\n/, ''
            File.write(path, formatted)
        rescue => e
            next
        end
    end
  end

  module_function :execute
end
