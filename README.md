# Pocus

[![Gem Version](https://badge.fury.io/rb/pocus.svg)](http://badge.fury.io/rb/pocus)
[![Code Climate GPA](https://codeclimate.com/github/varyonic/pocus.svg)](https://codeclimate.com/github/varyonic/pocus)
[![Travis CI Status](https://secure.travis-ci.org/varyonic/pocus.svg)](https://travis-ci.org/varyonic/pocus)

Unofficial Ruby API client for [iContact API](https://www.icontact.com/developerportal) (f.k.a. Vocus), inspired by Active Resource.

## Installation

Add to your application's Gemfile:

```ruby
gem 'pocus'
```

And then execute:

    $ bundle

## Requirements

iContact account, AppID and credentials, see the [iContact API Getting Started Guide](https://www.icontact.com/developerportal/documentation/start-building).

## Usage

Configure a connection and connect to the account:

```ruby
    credentials = { host: 'app.icontact.com', app_id: a, username: u, password: p }
    session = Pocus::Session.new(credentials)
    session.logger = Rails.logger
	account = Pocus::Account.new(session: session, account_id: account_id)
```

Navigate and update entities:

```ruby
	folder = acount.clientfolders.find(folder_id)
	folder.contacts.create(contacts_data)
```

See the specs for sample code.

## Tests

To run the tests you will need your own iContact account with a test folder (name: 'My First List').  Set the following environment variables:

```
POCUS_APP_ID=0b34...b478c
POCUS_USERNAME=vocus_api_sandbox@....com
POCUS_PASSWORD=...
POCUS_TEST_ACCOUNT=99...99
POCUS_TEST_CLIENT_FOLDER=9...9
```
To test, run:

    bundle exec rake

## Contributions

Read [CONTRIBUTING](CONTRIBUTING.md) for details.

## History

Read the [CHANGELOG](CHANGELOG.md) for details.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Read the [LICENSE](LICENSE.md) for details.

Copyright (c) 2016-2019 [Varyonic](https://www.varyonic.com).
