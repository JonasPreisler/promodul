require 'swagger_helper'

describe 'SubCategory', type: :request do

  path '/{locale}/role_groups' do
    post 'Create Roles' do
      tags 'Role Management'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path, type: :string, required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name:         { type: :string },
              product_group_permission_attributes: {
                  type: :object,
                  properties: {
                      show_data:     { type: :boolean },
                      read_data:     { type: :boolean },
                      create_data:   { type: :boolean },
                      edit_data:     { type: :boolean },
                      activate_data: { type: :boolean },
                      delete_record:   { type: :boolean }
                  }
              },
              product_type_permission_attributes: {
                  type: :object,
                  properties: {
                      show_data:     { type: :boolean },
                      read_data:     { type: :boolean },
                      create_data:   { type: :boolean },
                      edit_data:     { type: :boolean },
                      activate_data: { type: :boolean },
                      delete_record:   { type: :boolean }
                  }
              },
              product_import_permission_attributes: {
                  type: :object,
                  properties: {
                      show_data:     { type: :boolean },
                      import:   { type: :boolean }
                  }
              },
              product_catalog_permission_attributes: {
                  type: :object,
                  properties: {
                      show_data:       { type: :boolean },
                      read_data:       { type: :boolean },
                      create_data:     { type: :boolean },
                      edit_data:       { type: :boolean },
                      set_price_data:  { type: :boolean },
                      delete_record:   { type: :boolean }
                  }
              }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   role: {
                       type: :object,
                       properties: {
                           id:           { type: :integer },
                           name:         { type: :string },
                           created_at:   { type: :string },
                           updated_at:   { type: :string },
                       }
                   }
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end

    end
  end

  #path '/{locale}/departments' do
  #  put 'Update department' do
  #    tags 'Company'
  #    consumes 'application/json'
  #    produces 'application/json'
  #
  #    parameter({
  #                  in: :header,
  #                  type: :string,
  #                  name: :Authorization,
  #                  required: true,
  #                  description: 'JWT token'
  #              })
  #
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #    parameter name: :params, in: :body, schema: {
  #        type: :object,
  #        properties: {
  #            id:           { type: :integer },
  #            name:         { type: :string },
  #            description:  { type: :string },
  #            address:      { type: :string },
  #            phone_number: { type: :string },
  #            country_id:   { type: :integer },
  #            city_id:      { type: :integer },
  #            parent_id:    { type: :integer },
  #            company_id:   { type: :integer }
  #        }
  #    }
  #    response '201', 'ok' do
  #      schema type: :object,
  #             properties: {
  #                 department: {
  #                     type: :object,
  #                     properties: {
  #                         id: {type: :integer},
  #                         name: {type: :string},
  #                         description:  { type: :string },
  #                         address:      { type: :string },
  #                         phone_number: { type: :string },
  #                         parent_id:    { type: :integer },
  #                         company_id:   { type: :integer },
  #                         country: {
  #                             type: :object,
  #                             properties: {
  #                                 name: { type: :string }
  #                             }
  #                         },
  #                         city:    {
  #                             type: :object,
  #                             properties: {
  #                                 name: { type: :object }
  #                             }
  #                         }
  #                     }
  #                 }
  #             }
  #
  #      run_test!
  #    end
  #
  #    response '404', 'Not Found' do
  #
  #      run_test!
  #    end
  #
  #  end
  #end
  #
  #path '/{locale}/departments/department_list' do
  #  get 'Returns companies' do
  #    tags 'Company'
  #    consumes 'application/json'
  #
  #    parameter({
  #                  :in => :header,
  #                  :type => :string,
  #                  :name => :Authorization,
  #                  :required => true,
  #                  :description => 'Client token'
  #              })
  #
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #    parameter name: :company_id, in: :query, type: :integer, required: true
  #
  #    response '200', 'OK' do
  #      schema type: :object,
  #             properties: {
  #                 departments: {
  #                     type: :array,
  #                     items: {
  #                         properties: {
  #                             id: {type: :integer},
  #                             name: {type: :string},
  #                             description:  { type: :string },
  #                             address:      { type: :string },
  #                             phone_number: { type: :string },
  #                             parent_id:    { type: :integer },
  #                             country: {
  #                                 type: :object,
  #                                 properties: {
  #                                     name: { type: :string }
  #                                 }
  #                             },
  #                             city:    {
  #                                 type: :object,
  #                                 properties: {
  #                                     name: { type: :object }
  #                                 }
  #                             }
  #                         }
  #                     }
  #                 }
  #             }
  #
  #      run_test!
  #    end
  #
  #  end
  #end
  #
  #path '/{locale}/departments' do
  #  delete 'delete department' do
  #    tags 'Company'
  #    consumes 'multipart/form-data'
  #
  #    parameter({
  #                  in: :header,
  #                  type: :string,
  #                  name: :Authorization,
  #                  required: true,
  #                  description: 'JWT token'
  #              })
  #
  #    parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
  #    parameter name: :id,     in: :query,  type: :integer,  required: true
  #
  #    response '204', 'OK' do
  #
  #      schema type: :object,
  #             properties: {
  #                 success: { type: :boolean }
  #             }
  #
  #      run_test!
  #    end
  #
  #    response '404', 'Not Found' do
  #
  #      run_test!
  #    end
  #  end
  #end
  #
  #path '/{locale}/departments/sub_department_list' do
  #  get 'Returns sub companies' do
  #    tags 'Company'
  #    consumes 'application/json'
  #
  #    parameter({
  #                  :in => :header,
  #                  :type => :string,
  #                  :name => :Authorization,
  #                  :required => true,
  #                  :description => 'Client token'
  #              })
  #
  #    parameter name: :locale, in: :path, type: :string, required: true, default: "en"
  #    parameter name: :parent_id, in: :query, type: :integer, required: true
  #
  #    response '200', 'OK' do
  #      schema type: :object,
  #             properties: {
  #                 sub_departments: {
  #                     type: :array,
  #                     items: {
  #                         properties: {
  #                             id: {type: :integer},
  #                             name: {type: :string},
  #                             description:  { type: :string },
  #                             address:      { type: :string },
  #                             phone_number: { type: :string },
  #                             parent_id:    { type: :integer },
  #                             country: {
  #                                 type: :object,
  #                                 properties: {
  #                                     name: { type: :string }
  #                                 }
  #                             },
  #                             city:    {
  #                                 type: :object,
  #                                 properties: {
  #                                     name: { type: :object }
  #                                 }
  #                             }
  #                         }
  #                     }
  #                 }
  #             }
  #
  #      run_test!
  #    end
  #
  #    response '404', 'Not found' do
  #      schema type: :object,
  #             properties: {}
  #      run_test!
  #    end
  #
  #  end
  #end

end