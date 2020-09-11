module Products
  class ImportProductsWorker
    include Sidekiq::Worker

    sidekiq_options queue: 'import_products'

    def perform(params, current_user_id)
      current_user = UserAccount.find(current_user_id)

      ImportProductsService.new(current_user, params).call
    end
  end
end