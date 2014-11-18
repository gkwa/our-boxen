require boxen::environment
require homebrew
require gcc

Exec {
  group => 'staff',
  logoutput => on_failure,
  user => $boxen_user,

  path => [
           "${boxen::config::home}/rbenv/shims",
           "${boxen::config::home}/rbenv/bin",
           "${boxen::config::home}/rbenv/plugins/ruby-build/bin",
           "${boxen::config::home}/homebrew/bin",
           '/usr/bin',
           '/bin',
           '/usr/sbin',
           '/sbin'
           ],

  environment => [
                  "HOMEBREW_CACHE=${homebrew::config::cachedir}",
                  "HOME=/Users/${::boxen_user}"
                  ]
}

File {
  group => 'staff',
  owner => $boxen_user
}

Package {
  provider => homebrew,
  require => Class['homebrew']
}

Repository {
  provider => git,
  extra => [
            '--recurse-submodules'
            ],
  require => File["${boxen::config::bindir}/boxen-git-credential"],
  config => {
    'credential.helper' => "${boxen::config::bindir}/boxen-git-credential"
  }
}

Service {
  provider => ghlaunchd
}

Homebrew::Formula <| |> -> Package <| |>

node default {
  # core modules, needed for most things
  include dnsmasq
  include git
  include hub
  include nginx

  include firefox # requires emacs module in Puppetfile
  include skype
  include java
  # include eclipse #Fails
  # include eclipse::java #Fails
  include iterm2::stable
  # include docker
  include dropbox
  include chrome
  include silverlight
  include keepassx
  include homebrew
  include vlc
  include googledrive
  include tmux
  # include cyberduck # PKZip Signature error
  include virtualbox
  include python

  include osx::software_update

  # fail if FDE is not enabled
  if $::root_encrypted == 'no' {
    fail('Please enable full disk encryption and try again')
  }

  # node versions
  include nodejs::v0_6
  include nodejs::v0_8
  include nodejs::v0_10

  # default ruby versions
  ruby::version {
    '1.9.3':
  }
  ruby::version {
    '2.0.0':
  }
  ruby::version {
    '2.1.0':
  }
  ruby::version {
    '2.1.1':
  }
  ruby::version {
    '2.1.2':
  }

  # Homebrew packages
  # common, useful packages
  package {
    [
     'ack',
     'autossh',
     'aws-cfn-tools',
     'aws-cloudsearch',
     'aws-elasticache',
     'chrome-cli',
     'cmake',
     'coreutils',
     'ctags',
     'dos2unix',
     'ec2-ami-tools',
     'ec2-api-tools',
     'findutils',
     'gawk',
     'gnu-getopt',
     'gnu-indent',
     'gnu-sed',
     'gnu-tar',
     'gnutls',
     'go',
     'gradle',
     'graphviz',
     'groovy',
     'lua',
     'lynx',
     'maven',
     'mono',
     'p7zip',
     'parallel',
     'psgrep',
     'readline',
     'ssh-copy-id',
     'stow',
     'subversion',
     'tree',
     'unix2dos',
     'wget',
     'wiggle',
     'xml-coreutils'
     ]:
  }

  package {
    'elasticsearch': provider => 'homebrew',
    ensure => 'present',
  }

  file {
    "${boxen::config::srcdir}/our-boxen": ensure => link,
    target => $boxen::config::repodir
  }
}
