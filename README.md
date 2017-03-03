Client Auth
----------------

Client Authentication gem for Matic clients.

Releasing
---------

For the version releasing we are using [Geminabox](https://github.com/tomlea/geminabox) 
It need to be installed separately:
- `gem install geminabox --no-rdoc --no-ri`
- `gem inabox -c`

To Release new version:
- `bash bin/release <version_number>`

To integrate in you project, please add next:

    source 'http://<user_name>:<pass_creds>@gems.maticinsurance.com:9292/' do
      gem 'client-auth'
    end
