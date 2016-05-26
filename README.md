# Pocus

[![Gem Version](https://badge.fury.io/rb/pocus.svg)](http://badge.fury.io/rb/pocus)
[![Code Climate GPA](https://codeclimate.com/github//pocus.svg)](https://codeclimate.com/github//pocus)
[![Code Climate Coverage](https://codeclimate.com/github//pocus/coverage.svg)](https://codeclimate.com/github//pocus)
[![Gemnasium Status](https://gemnasium.com//pocus.svg)](https://gemnasium.com//pocus)
[![Travis CI Status](https://secure.travis-ci.org//pocus.svg)](https://travis-ci.org//pocus)

<!-- Tocer[start]: Auto-generated, don't remove. -->

# Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [Usage](#usage)
- [Tests](#tests)
- [Versioning](#versioning)
- [Code of Conduct](#code-of-conduct)
- [Contributions](#contributions)
- [License](#license)
- [History](#history)
- [Credits](#credits)

<!-- Tocer[finish]: Auto-generated, don't remove. -->

# Features

Unofficial Ruby API client for [iContact API](See https://www.icontact.com/developerportal), fka. Vocus

# Requirements

0. [MRI 2.3.0](https://www.ruby-lang.org)

# Setup

For a secure install, type the following (recommended):

    gem cert --add <(curl --location --silent https://www.varyonic.com/gem-public.pem)
    gem install pocus --trust-policy MediumSecurity

NOTE: A HighSecurity trust policy would be best but MediumSecurity enables signed gem verification while
allowing the installation of unsigned dependencies since they are beyond the scope of this gem.

For an insecure install, type the following (not recommended):

    gem install pocus

Add the following to your Gemfile:

    gem "pocus"

# Usage

# Tests

To run the tests you will need your own iContact account with a test folder.  Populate ~/.pocus/fixtures.yml as follows:

```
	credentials:
	  app_id: ...
	  username: ...
	  password: ...
	account_id: ...
	test_client_folder_id: ...
```
To test, run:

    bundle exec rake

# Versioning

Read [Semantic Versioning](http://semver.org) for details. Briefly, it means:

- Patch (x.y.Z) - Incremented for small, backwards compatible bug fixes.
- Minor (x.Y.z) - Incremented for new, backwards compatible public API enhancements and/or bug fixes.
- Major (X.y.z) - Incremented for any backwards incompatible public API changes.

# Code of Conduct

Please note that this project is released with a [CODE OF CONDUCT](CODE_OF_CONDUCT.md). By participating in this project
you agree to abide by its terms.

# Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

# License

Copyright (c) 2016 [Varyonic](https://www.varyonic.com).
Read the [LICENSE](LICENSE.md) for details.

# History

Read the [CHANGELOG](CHANGELOG.md) for details.
Built with [Gemsmith](https://github.com/bkuhlmann/gemsmith).

# Credits

Developed by [Piers Chambers](https://www.varyonic.com) at [Varyonic](https://www.varyonic.com).
