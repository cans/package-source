cans.package-source
===================

[![Build Status](https://travis-ci.org/cans/package-sources.svg?branch=master)](https://travis-ci.org/cans/package-sources)
[![Ansible Galaxy](https://img.shields.io/badge/ansible--galaxy-cans.package--source-blue.svg?style=flat-square)](https://galaxy.ansible.com/cans/package-source)
[![License](https://img.shields.io/badge/license-GPLv2-brightgreen.svg?style=flat-square)](LICENSE)

Simple role to add and / or remove distribution package sources and
their respective GPG keys.


Each package source to be added or removed must be described as
follows:

    - repo: "name of the repository"      # required
      codename: "<Distro codename>"       # optional, default: undefined
      key_id: "<GPG Key ID>"              # optional, default: undefined
      key_server: "<key server url>"      # optional, default: undefined
      key_url: "<public key file url>"    # optional, default: undefined
      keyring: "<path to keyring>"        # optional, default: undefined
      update_cache: <yes|no>              # optional, default: no

This role will add, then remove sources. And since the repositories
are specified in lists, the order in which they are added or removed is
deterministic and as specified in your playbook.

All values with an _undefined_ default will simply be omitted if not
specified.

The `repo` is the one and only mandatory value and should be a valid
APT repository description line.

If you want to install a key alongside a given source, you *must*
specify the `key_id`, to avoid inserting undesired key in APT's
keyring. Then either of `key_url` or `key_server` become mandatory, so
the key can be retrieve somehow.

Changing the default value of `update_cache` is generally not a good
idea, as slows down your playbook terribly. And anyways, if you add
package sources, it is most likely to use them a short while latter. It
is recommanded to update the cache then and not when you add the source.
Note that is has the drawback of not validating your new repositories.
If you still want that validation to occur during the execution of this
role, use `update_cache` has shown in the
[example playbook](#example-playbook) below.


Requirements
------------

This package has the requirements of Ansible's distribution package
sources management modules:

- For Debian based distributions see [apt\_repository](http://docs.ansible.com/ansible/apt_repository_module.html)
  and [apt\_key](http://doc.ansible.com/ansible/apt_key_module.html) modules;
  


Role Variables
--------------

All the variables from this module are namespaced with the prefix
`pkgsources`.

- `pkgsource_present`: the list of sources you want to make sure are
  available (default: `[]`);
- `pkgsource_absent`: the list of sources you want to make sure are
  *not* available (default: `[]`);
- `pkgsource_user`: the user to connect as to update the sources
  on the target hosts (default: `ansible_user_id`).


Dependencies
------------

This role has no external dependencies.


Example Playbook <a name="example-playbook"></a>
----------------

In this playbook, we add two new sources to APT and remove one.
With the second added source, we will also install the repository's GPG 
key. Finally, since this role adds then removes repositories, on the
last (and only) removed repository removed, we force a cache update
that ensure the configuration is valid indeed and APT can verify all
repositories and packages signatures.

    - hosts: servers
      roles:
         - role: "cans.package-source"
           pkgsource_present:
             # Simply ensure Debian current release backport packages repository
             # is available
             - repo: "deb http://ftp.fr.debian.org/debian/ stable-backports main"

             # Heroku's toolbelt repository (cli tool)
             - repo: "deb https://toolbelt.heroku.com/ubuntu/ ./"
               # These two lines will ensure Heroku's GPG key is intalled *before*
               # adding the repository to the source list.
               key_id: C927EBE00F1B0520
               key_url: "https://toolbelt.herokuapp.com/apt/release.key"

           # The deprecated sources you want removed.
           pkgsource_absent:
             - "deb http://ftp.fr.debian.org/debian/ wheezy main"
               # Force cache update on last repository added or removed so the new
               # configuration is validated
               update_cache: yes


License
-------

The Ansible role package-source is free software: you can
redistribute it and/or modify it under the terms of the GNU General
Public License version 2 as published by the Free Software Foundation.

package-sources is distributed in the hope that it will be useful, but
WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
General Public License for more details.

You should have received a copy of the GNU General Public License
along with package-sources. If not, see <http://www.gnu.org/licenses/>.


Author Information
------------------

Copyright © 2017, Nicolas CANIART.
