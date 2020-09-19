Chewy.logger = Logger.new(STDOUT)
Chewy.logger.level = Logger::INFO
Chewy.settings = Rails.application.config_for(:chewy)
Chewy.strategy(:atomic)
