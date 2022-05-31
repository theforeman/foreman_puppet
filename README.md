# ForemanPuppet

[![Gem Version](https://img.shields.io/gem/v/foreman_puppet.svg)](https://rubygems.org/gems/foreman_puppet)
[![GPL License](https://img.shields.io/github/license/theforeman/foreman_puppet.svg)](https://github.com/theforeman/foreman_puppet/blob/master/LICENSE)

This plugin adds Puppet External node classification functionality to [Foreman](https://theforeman.org).

* Website: [theforeman.org](http://theforeman.org)
* Support: [Foreman support](http://theforeman.org/support.html)

## Features

* Puppet dashboards
* Puppet
  * Environments
  * Classes
  * Config groups
  * Smart Class parameters
* Host / Hostgroup
  * Classes assignment
  * Environment assignment
  * Puppet proxy assignment
* Puppet ENC (external node classifier)
* Smartproxy Puppet status/tab
* Template hostgroup / environment

Some features will remain in core:

* PuppetCA
* Report/Fact parsing

## Compatibility

Foreman 3.0 will be the first release where the Puppet functionality is mostly extracted.
Therefore, this plugin is only required for 3.0 and onwards.
You can install it on Foreman 2.5 to prepare for the Foreman update.

|Foreman version|Plugin version|Notes                                     |
|---------------|--------------|------------------------------------------|
| >= 3.3        | ~> 4.0       | Required                                 |
| >= 3.2        | ~> 3.0       | Required                                 |
| ~> 3.1        | ~> 2.0       | Required                                 |
| ~> 3.0        | ~> 1.0       | Required                                 |
| >= 2.5        | ~> 0.1       | Optional; replaces Core features         |
| < 2.5         | -            | Not supported (functionality is in Core) |

## Installation

See [How_to_Install_a_Plugin](https://theforeman.org/plugins/#2.Installation)
for how to install Foreman plugins

You can manually install this plugin using:

```sh
# On RedHat/CentOS
yum install tfm-rubygem-foreman_puppet

# On Debian
apt install ruby-foreman-puppet
```

## Usage

The usage is identical to the prior core functionality:

* Import *environments* and *classes* from a Smartproxy
* Optionally define *Smart Class* parameters
* Assign *environment* and *classes* to *Hosts / Hostgroups*
* Use the *Puppet ENC* on your Puppetserver(s) to query Foreman

## Problems

Please feel free to open a [new Github issue](https://github.com/theforeman/foreman_puppet/issues/new)
if you encounter any bugs/issues using this plugin.

## Contributing

Fork and send a Pull Request. Thanks!

## Copyright

Copyright (c) *2022* *The Foreman developers*

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
