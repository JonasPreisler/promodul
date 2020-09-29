module ProductHelper
  def product_characteristics_schema
    {
        product_characteristic: {
            except: [:product_id, :sub_category_id, :product_type_id, :product_vat_type_id],
            include: {
                product_type:     { only: [:id, :name, :id_name] },
                product_vat_type: { only: [:id, :name, :id_name] },
                sub_category:     { only: [:id, :name, :id_name],
                                    include: {
                                        category: { only: [:id, :name, :id_name] }
                                    }},
            }
        }
    }
  end
end