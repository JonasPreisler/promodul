module Products
  class EsSearchService
    include Umg::ErrorsFormat
    require 'chewy_helper'

    attr_reader :search_params, :errors, :response_code, :total, :search_result


    def initialize(params, customer)
      @search_params = params
      @page_limit = params[:page_limit] || 10
      @search_params[:page_limit] = @page_limit
      @multi_language_fields = %w"name full_name generic promotion_description promotion_title"
      @customer = customer

      @errors = []
    end

    def search_a_product
      @result = ProductsIndex
                    .track_scores(true)
                    .query(build_query)
                    .order(build_sort_query)
                    .per(@page_limit.to_i).page(@search_params[:page])
    rescue => e
      Rails.logger.warn("Elasticsearch ERROR: Product search service #{e}")
    end

    private


    def build_query
      #ToDo: Here goes query build hash
    end

    def build_sort_query
      #ToDo: Here goes sort query build hash
    end
  end
end