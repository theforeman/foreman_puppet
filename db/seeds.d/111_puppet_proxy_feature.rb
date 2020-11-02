# frozen_string_literal: true

proxy_features = %w[Puppet]

proxy_features.each do |f_name|
  f = Feature.where(name: f_name).first_or_create
  raise "Unable to create proxy feature: #{format_errors f}" if f.nil? || f.errors.any?
end
