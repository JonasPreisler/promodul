module PgSqlHelper
  extend ActiveSupport::Concern

  def self.included(base)

  end

  def pg_timestamp_without_time_zone
    "(now() AT TIME ZONE 'UTC')"
  end

  # Creates methods pg_interval_hour(3) and etc.
  %w(second seconds minute minutes hour hours day days).each do |method_name|
    define_method "pg_interval_#{method_name}" do |number|
      "interval '#{ number } #{method_name}'"
    end
  end
end
