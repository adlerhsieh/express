RSpec.configure do |config|

  keep_tables = %w[
    ar_internal_metadata
  ]

  config.before(:suite) do |group|
    DatabaseCleaner.clean_with(:truncation, except: keep_tables)
  end

  config.before(:all) do
    # if self.class.metadata[:clean]
      DatabaseCleaner.clean_with(:truncation, except: keep_tables)
    # end
  end

  config.before(:each) do |group|
    # if group.metadata[:type] == :model || group.metadata[:transaction]
    #   DatabaseCleaner.strategy = :transaction
    # else
      DatabaseCleaner.strategy = :truncation, { except: keep_tables }
    # end
    #
    # auto_clean_spec_types = %i(request)
    #
    # if group.metadata[:clean] || auto_clean_spec_types.include?(group.metadata[:type])
      DatabaseCleaner.start
    # end
  end

  config.after(:each) do |group|
    # auto_clean_spec_types = %i(request)

    # if group.metadata[:clean] || auto_clean_spec_types.include?(group.metadata[:type])
      DatabaseCleaner.clean
    # end
  end

  # rspec-rails 3 will no longer automatically infer an example group's spec type
  # from the file location. You can explicitly opt-in to the feature using this
  # config option.
  # To explicitly tag specs without using automatic inference, set the `:type`
  # metadata manually:
  #
  #     describe ThingsController, :type => :controller do
  #       # Equivalent to being in spec/controllers
  #     end
  config.infer_spec_type_from_file_location!
end


