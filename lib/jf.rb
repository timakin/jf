require 'jf/version'
require 'ext'
require 'json'

class FileParseError < StandardError; end

module Jf
    def self.execute(target, opts)
        if target.is_stdin
            parse_stdin(target.body, opts)
            return
        end

        if File.exist?(target.body)
            paths = opts[:gitdiff] ? get_diff_list.split(/$/).map(&:strip) : get_path_list(target.body)
        else
            assert_file_not_found
            exit
        end

        for path in paths
            next if is_not_json(path)
            begin
                if opts[:minify]
                    minify(path)
                elsif opts[:merge]
                    merge(path, opts)
                else
                    rewrite(path, opts)
                end
            rescue FileParseError => e
                assert_parse_failed
                next
            end
        end
    end

    def self.get_diff_list
        `git status | egrep "$*.json" | sed -E "s/([^:]+: +)(.*)/\\2/"`
    end

    def self.get_path_list(path)
        File.directory?(path) ? Dir.glob("#{path}/**/*.json") : Dir.glob(path)
    end

    def self.apply_format(target, opts)
        data_hash = JSON.parse(target)
        indent = !opts[:indent].nil? ? ' ' * opts[:indent].to_i : '  '
        formatted = JSON.pretty_generate(data_hash, indent: indent).gsub /^$\n/, ''
        formatted
    end

    def self.merge(origin, opts)
        origin_json = JSON.parse(File.read(origin))
        target_json = JSON.parse(File.read(opts[:merge]))
        if opts[:key]
            target_keys = opts[:key].split('.')
            origin_json = origin_json.deep_merge(*target_keys, target_json)
        else
            origin_json = origin_json.merge(target_json)
        end
        File.write(origin, origin_json.to_json)
        rewrite(origin, opts)
    end

    def self.rewrite(path, opts)
        return if opts[:noformat]
        File.write(path, apply_format(File.read(path).force_encoding('UTF-8'), opts))
    end

    def self.parse_stdin(stdin, opts)
        puts apply_format(stdin, opts)
    end

    def self.minify(path)
        File.write(path, JSON.parse(File.read(path).force_encoding('UTF-8')).to_json)
    end

    def self.is_not_json(path)
        /.+.json/ !~ path
    end

    def self.assert_file_not_found
        puts '[Error] Could not find directory ot file.'
    end

    def self.assert_parse_failed
        puts '[Error] Could not parse json correctly.'
    end
end
