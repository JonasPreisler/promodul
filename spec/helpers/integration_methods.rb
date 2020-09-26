require 'swagger_helper'

def multilanguage_fields
  { I18n.default_locale =>  { type: :string } }
end

def product_schema
  {
      name:        { type: :string },
      full_name:   { type: :string },
      description: { type: :string },
      instruction: { type: :string },
      code:        { type: :string },
      product_characteristic: {
          type: :object,
          properties: {
              volume:        { type: :string },
              manufacturer:  { type: :string },
              description:   { type: :string },
              external_code: { type: :string },
              sales_start:   { type: :string },
              sales_end:     { type: :string },
              EAN_code:      { type: :string },
              weight:        { type: :number },
              height:        { type: :number },
              width:         { type: :number },
              depth:         { type: :number },
              subscription:  { type: :boolean },
              commission:    { type: :boolean },
              sub_category: {
                  type: :object,
                  properties: {
                      name:    { type: :string },
                      id_name: { type: :string }
                  }
              },
              product_type: {
                  type: :object,
                  properties: {
                      name:    { type: :string },
                      id_name: { type: :string }
                  }
              },
              product_vat_type: {
                  type: :object,
                  properties: {
                      name:    { type: :string },
                      id_name: { type: :string }
                  }
              },
          }
      }
  }
end