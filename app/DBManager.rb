require 'active_record'

class DBManager

  def db_configuration
    db_configuration_file = File.join(File.expand_path('..', __FILE__), '..', 'db', 'config.yml')
    YAML.load(File.read(db_configuration_file))
  end

  def establish_connection
    ActiveRecord::Base.establish_connection(db_configuration["development"])
  end

end
