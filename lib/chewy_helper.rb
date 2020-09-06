module ChewyHelper

  def self.refactor_hash_by_multi_language(result_hash, multi_language_fields)

    result_hash.each do |key, hash_value|
      result_hash[key] = MultiLanguage.value(hash_value) if array_includes_key?(multi_language_fields, key)

      refactor_hash_by_multi_language(hash_value, multi_language_fields) if hash_value.is_a?(Hash)

      if hash_value.is_a?(Array)
        hash_value.each do |inner_elem|
          refactor_hash_by_multi_language(inner_elem, multi_language_fields)
        end
      end
    end
  end

  def self.array_includes_key?(multi_language_fields, key)
    includes = false

    multi_language_fields.each do |field|
      if key.to_s.include?(field)
        includes = true
        break
      end
    end

    includes
  end

  def self.get_min_med_price_for_provider(product)
    SupplierProductPrice
        .select("MIN(supplier_product_prices.price) AS price")
        .joins("LEFT JOIN supplier_products AS pm ON supplier_product_prices.supplier_product_id = pm.id")
        .where("product_id = :product_id AND is_active = :active", { product_id: product.id, active: true })
        .group("product_id")[0]&.price.to_f || 0
  end

  def self.get_min_sell_amount_for_provider(product)
    SupplierProduct
        .select("MIN(supplier_products.min_sell_amount) AS min_sell_amount")
        .where("product_id = :product_id AND is_active = :active", { product_id: product.id, active: true })
        .group("product_id")[0]&.min_sell_amount.to_f
  end

  def self.products_name_object(product)
    if !product['name']['en'].present?
      product['name']['en'] = product['name']['no']
    end

    product['name']
  end
end