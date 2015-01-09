class people::taylormonacelli {

  include emacs # requires emacs module in Puppetfile

  include osx::global::tap_to_click
  include osx::no_network_dsstores
  include osx::global::enable_keyboard_control_access
  include osx::global::disable_autocorrect
  include osx::finder::unhide_library
  include osx::disable_app_quarantine
  include osx::no_network_dsstores

  include eclipse::java

  # Set the default value (35)
  # include osx::global::key_repeat_delay
  class { 'osx::global::key_repeat_delay':
    delay => 0
  }
  # https://github.com/boxen/puppet-osx
  class { 'osx::global::key_repeat_rate':
    rate => 0
  }

  $home     = "/Users/${::boxen_user}"
  $my       = "${home}/my"
  $dotfiles = "${my}/dotfiles"

  file { $my:
    ensure  => directory
  }

  package { 'boto':
    ensure   => latest,
    provider => pip,
  }
  package { 'keyring':
    ensure   => latest,
    provider => pip,
  }
  package { 'jsbeautifier':
    ensure   => latest,
    provider => pip,
  }
  package { 'selenium':
    ensure   => latest,
    provider => pip,
  }
  package { 'google-api-python-client':
    ensure   => latest,
    provider => pip,
  }

  nodejs::module { 'js-beautify':
    node_version => 'v0.10'
  }
  nodejs::module { 'uglify-js':
    node_version => 'v0.10'
  }
  nodejs::module { 'grunt-cli':
    node_version => 'v0.10'
  }

  repository { $dotfiles:
    source  => 'taylormonacelli/dotfiles',
    require => File[$my]
  }
}
