class people::taylormonacelli {

  include emacs # requires emacs module in Puppetfile

  include osx::global::tap_to_click
  include osx::no_network_dsstores

  # Set the default value (35)
  # include osx::global::key_repeat_delay
  class { 'osx::global::key_repeat_delay':
    delay => 0
  }

  # Set the default value (0)
  # include osx::global::key_repeat_rate

  $home     = "/Users/${::boxen_user}"
  $my       = "${home}/my"
  $dotfiles = "${my}/dotfiles"

  file { $my:
    ensure  => directory
  }

  package { 'boto': provider => pip, ensure => latest }
  package { 'keyring': provider => pip, ensure => latest }
  package { 'jsbeautifier': provider => pip, ensure => latest }
  package { 'selenium': provider => pip, ensure => latest }
  package { 'google-api-python-client': provider => pip, ensure => latest }

  nodejs::module { 'js-beautify': node_version => 'v0.10' }
  nodejs::module { 'uglify-js': node_version => 'v0.10' }
  nodejs::module { 'grunt-cli': node_version => 'v0.10' }

  repository { $dotfiles:
    source  => 'taylormonacelli/dotfiles',
    require => File[$my]
  }
}
