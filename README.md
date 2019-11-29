## Client Auth

Client Authentication gem for Matic clients.

Master status: ![](https://github.com/matic-insurance/client-auth/workflows/ci/badge.svg?branch=master)

## Installation

- `git clone git@github.com:matic-insurance/client-auth.git`
- `gem install bundler:1.14.5`
- `bundle install`

## Releasing

- Merge all PR to master
- Create new named release `x.x.x`
- CI will run tests and publish new gem automatically
- Check [GitHub Actions](https://github.com/matic-insurance/client-auth/actions) for more details 

To integrate in you project, please add next:

    source "https://rubygems.pkg.github.com/matic-insurance" do
      gem "client-auth", "1.1.0"
    end
