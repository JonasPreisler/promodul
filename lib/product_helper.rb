module ProductHelper
  def product_characteristics_schema
    {
        product_characteristic: {
            except: [:product_id, :sub_category_id, :product_type_id, :product_vat_type_id],
            include: {
                sub_category:     { only: [:name, :id_name] },
                product_type:     { only: [:name, :id_name] },
                product_vat_type: { only: [:name, :id_name] }
            }
        }
    }
  end
end