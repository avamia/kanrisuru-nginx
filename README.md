# Kanrisuru::Nginx

This project helps you manage your remote Nginx webservers. Built ontop of the [Kanrisuru library](https://github.com/avamia/kanrisuru), it utilizes the core set of commands to install, service and configure the Nginx webserver.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kanrisuru-nginx'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kanrisuru-nginx

## Usage

The nginx module is namespaced on a `host` and `cluster` instance under the `nginx` name.

### Requirment

To use `Kanrisuru::Nginx` in your project, make sure to include both projects to manage the infrastructure. 
```ruby
require 'kanrisuru'
require 'kanrisuru-nginx'
```

Most commands with nginx need to be run as root, so don't forget to call the `su` method before running the nginx module.

### Package Installation
Installation of the nginx package is straightforward.  You can check if the package is installed directly with the `installed?` method.

```ruby
host.su('root')
host = Kanrisuru::Remote::Host.new(host: 'centos-host', username: 'centos', keys: ['~/.ssh/id-rsa'])

host.nginx.installed?
# => false

result = host.nginx.install
result.success?
# => true 

host.nginx.installed?
# => true
```

The installation is installed via the `apt`, `yum`, and `zypper` package managers for their respective linux distribution types, namely:
| Package Manager | OS Distro |
|-----------------|-----------|
| `apt` | debian |
| `apt` | ubuntu |
| `yum` | centos |
| `yum` | redhat |
| `yum` | fedora |
| `zypper` | opensuse |
| `zypper` | SUSE Enterprise Linux |

With Kanrisuru, the `os_include` and `os_define` takes care of figuring out which linux distro and release should be used with the corresponding install method, so you only need to call `host.nginx.install` for it to work. 

### Package Removal
To remove an installed version of Nginx, call:
```ruby
host.nginx.installed?
# => true

host.nginx.remove

host.nginx.installed?
# => false
``` 

Note that if Nginx is running while calling remove, it will automatically stop any master / worker processes that are running before removing the package.

### Service Methods
To service the nginx webserver, the following commands help you easily start, stop, and restart the webserver
```ruby
host.nginx.running?
# => false

## Start the webserver
result = host.nginx.start
result.success?
# => true

host.nginx.running?
# => true

host.nginx.master_pid
# => 1337

result = host.nginx.restart
result.success?
# => true

host.nginx.master_pid
# => 4343

result = host.nginx.stop
result.success?
# => true

host.nginx.running?
# => false
```

You can test to see if the current configuration files are properly formatted
```ruby
result = host.nginx.test
result.success?
# => true

result = host.nginx.test(config: '~/test.conf')
result.success?
# => true
```

To reload the nginx workers with updated configuration files, but not a full restart
```ruby
host.nginx.master_pid
# => 4343

result = host.nginx.reload
result.success?
# => true

host.nginx.master_pid
# => 4343
``` 

### Configuration Management
This is currently in development and is the focus of the next release for this module.

### Utilities
You can fetch the master and worker process information
```ruby
host.nginx.master_process
#<Struct:Kanrisuru::Core::System::ProcessInfo:0x000005f0
  ppid = 1,
  command = "nginx: master process nginx",
  cpu_time = "00:00:00",
  cpu_usage = 0.0,
  flags = 1,
  gid = 0,
  group = "root",
  memory_usage = 0.0,
  pid = 20484,
  policy = "SCHED_OTHER",
  policy_abbr = "TS",
  priority = 19,
  stat = "Ss",
  uid = 0,
  user = "root"
>

host.nginx.master_pid
# => 20484

host.nginx.worker_processess
[
  #<Struct:Kanrisuru::Core::System::ProcessInfo:0x0000f4d8
    ppid = 20484,
    command = "nginx: worker process",
    cpu_time = "00:00:00",
    cpu_usage = 0.0,
    flags = 5,
    gid = 994,
    group = "nginx",
    memory_usage = 0.0,
    pid = 20485,
    policy = "SCHED_OTHER",
    policy_abbr = "TS",
    priority = 19,
    stat = "S",
    uid = 997,
    user = "nginx"
  >
]
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/avamia/kanrisuru-nginx. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/avamia/kanrisuru-nginx/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kanrisuru::Nginx project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/avamia/kanrisuru-nginx/blob/master/CODE_OF_CONDUCT.md).
