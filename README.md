JF
=====

Dead simple JSON Formatter

## Example

```
$ jf raw.json [--gitdiff|--minify|-i] # Attach format to a json file.
$ jf .                                # Attach format to all of json files under the current directory.
$ cat raw.json | jf                   # Output pretty json for the received STDIN.
> (print pretty json)

# Merge options
$ jf origin.json --merge target.json                        # Push the object of inside of target.json back to the origin.json.
$ jf origin.json --merge target.json --key key1             # Push the object of inside of target.json to "key1" object of origin.json.
$ jf origin.json --merge target.json --key key1.innerkey1.0 # Push the object of inside of target.json to "origin[:key1][:innerkey1][:deep][0]".
```

## Options

- --git-diff
 - Run the command to only git-historically created|modified json file
- --minify
 - Compact multi lined json to one line
- -i {number}
 - Set the number of indents before the begining of each lines
- --merge {target.json} --key {keys}
 - Merge another json object to the specified json.
 - It supports deep inside object merge with '--key' option. You can set the option with dot-connected keys.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/timakin/jf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
