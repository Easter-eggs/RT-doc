# Request Tracker (unofficial) developer doc

The aim of this repo is to make a clean and efficient documentation for developping around [Request Tracker](https://www.bestpractical.com/rt-and-rtir) v4.

Official documentation sources are:
  - [RT website](https://docs.bestpractical.com/rt/4.4.0/index.html) (the "Developer Documentation" section is actually the API for *scrip*ing and extentions)
  - [RT Wiki](https://rt-wiki.bestpractical.com./)

Official user documentation is very clear and complete; and wiki is a good source but there is no quick beginner dev documentation. This is the aim of this project: help for the first steps of getting into RT.

## Getting ready

First of all, you'll have to **install RT**. The [Development installation guide](http://requesttracker.wikia.com/wiki/DevelopmentInstallation) in the wiki is a good starting point.

### RT_SiteConfig.pm

  - **etc/RT_SiteConfig.pm** is the config file for RT (the one you want to edit)
  - **etc/RT_Config.pm** containts all the possible keys for this file with doc

The first conf to add to this file is:

```perl
# avoid "Possible cross-site request forgery" alerts in every post request
Set(@ReferrerWhitelist, qw(127.0.0.1:8080));

# Disable cache
Set($DevelMode, 1);
```

More details of RT_Config.pm file [can be found on the wiki](http://requesttracker.wikia.com/wiki/SiteConfig)

### Run RT

    sbin/rt-server --port 8080

## Reading this doc

We advise you to read this doc in this order:
  - [general.md](general.md): containts general things to know that are used in all other files
  - [callbacks.md](callbacks.md): if you plan to write scrips
  - [snippets.md](snippets.md): basic snippets
  - have a look to `examples` folder for advanced examples
