## About
This project is designed to automatically build packages for Mattermost. It uses
`vagrant` and `fpm` to do so.

## Mac Setup
You will need vagrant and virtualbox. The easiest way to install that is to setup
[Homebrew](http://brew.sh/). To install it run:
```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
Next, use Homebrew to install Vagrant.
```
brew cask install virtualbox
brew cask install vagrant
```

## Usage
Run `vagrant up` in the appropriate directory to create packages.

*Note*: the first usage may require downloading the vagrant box, which is a large download. Future uses will not.

## Optional package caching
```
vagrant plugin install vagrant-cachier
```
This will cache a vagrant plugin, [vagrant-cachier](https://github.com/fgrehm/vagrant-cachier) which will attempt to cache apt downloads so that repeated package builds will be faster.
