# Express

## Setup

### 1. Clone & Bundle

```
git clone https://github.com/adlerhsieh/express.git
bundle
```

### 2. Setup DB

This project uses MySQL as default. Rename `config/application.example.yml` to `config/application.yml` and assign values to the following:

```yaml
DB_HOST:
DB_USERNAME:
DB_PASSWORD:
DB_PORT:
```

### 3. Secrets

Find `config/secrets.example.yml` and change it to `config/secrets.yml`, and find the following part:

```ruby
development:
  secret_key_base: # your secrets

test:
  secret_key_base: # your secrets

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: # your secrets
```

Use `rake secret` three times and paste them respectively into three key_base.

### 4. Migrate DB

Run `rake db:create db:migrate`

### Optional: ActionMailer

ActionMailer is turned on by default. If you are using it, check `config/environments/development.rb` and `config/environments/production.rb` as:

```ruby
ActionMailer::Base.smtp_settings = {
    :port           => 587,
    :address        => 'smtp.gmail.com',
    :user_name      => ENV["gmail_user"],
    :password       => ENV["gmail_pass"],
    :authentication => "plain",
    :domain => ENV["gmail_domain"],
    :enable_starttls_auto => true
  }
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.default(:from => "特快車")
config.action_mailer.raise_delivery_errors = true
config.action_mailer.default_url_options = {:host => "localhost:3000"}
```

Change them to other mailing service if you like. If nothing is set, there will be exceptions when using email subscription or shooping carts.



