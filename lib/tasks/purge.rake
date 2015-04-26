task :import do
  connection = ActiveRecord::Base.connection
  # tables = connection.tables
  # tables.each do |table_name|
  #   connection.execute("TRUNCATE `#{table_name}`")
  # end
end
