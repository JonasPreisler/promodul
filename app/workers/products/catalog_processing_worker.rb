module Products
  class CatalogProcessingWorker
    include Sidekiq::Worker

    sidekiq_options queue: 'catalog_processing'

    def perform(params, current_user_id)
      current_user = UserAccount.find(current_user_id)

      Products::CatalogProcessingService.new(current_user, params).call
    end
  end
end