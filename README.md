# Express

Express is a blogging application I'm now using with [Motion Express](http://motion-express.com/).

## To Anyone who may concern

If you are looking for my code sample, start from [app/models/order.rb](https://github.com/adlerhsieh/express/blob/master/app/models/store/order.rb) and related [controller actions](https://github.com/adlerhsieh/express/blob/master/app/controllers/store/orders_controller.rb) and [views](https://github.com/adlerhsieh/express/blob/master/app/views/store/orders/index.html.erb). Those are the code for [the store and shopping cart](http://motion-express.com/store/products).

More to checkout in [app/models/post.rb](https://github.com/adlerhsieh/express/blob/master/app/models/post.rb) in post management feature.

## Keywords

#### Backend

- MySQL
- Capistrano (Digital Ocean)
- RSpec
- ERB
- Github login
- PayPal checkout
- ActionMailer with Gmail

#### Frontend

- ACE editor
- jQuery
- AngularJS

## Features

- Post Management with ease
- Post Tags & Categories
- Video Trainings & Tutorials Management
- Email Subscription
- Github Login
- Store & Shopping Cart

## Installation

### 1. Clone & Bundle

```
git clone https://github.com/adlerhsieh/express.git
bundle
```

### 2. Setup DB

This project uses MySQL as default. Go to `config/database.example.yml` and change it to `config/database.yml` with your username, password, db name in the content.

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

Run `rake db:migrate`

### Optional: Services

All sensetive information is kept with [Figaro](https://github.com/laserlemon/figaro), which allows you to keep all info in `config/application.yml`. 

Change `config/application.example.yml` into `config/application.yml` and fill arguments with services you want to implement.

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



