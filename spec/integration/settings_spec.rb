require 'swagger_helper'

describe 'ProductType ', type: :request do
  path '/{locale}/settings/country' do
    post 'Add country into the system' do
      tags 'Settings'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name:         { type: :string },
              country_code: { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   country: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           country_code: {type: :string}
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

  path '/{locale}/settings/machine_model' do
    post 'Add machine model into the system' do
      tags 'Settings'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name:         { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   machine_model: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           id_name: {type: :string}
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

  path '/{locale}/settings/tool_model' do
    post 'Add tool model into the system' do
      tags 'Settings'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name:         { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   tool_model: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           id_name: {type: :string}
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

  path '/{locale}/settings/external_source_type' do
    post 'Add external_source_type into the system' do
      tags 'Settings'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              name:         { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   external_type: {
                       type: :object,
                       properties: {
                           id: {type: :integer},
                           name: {type: :string},
                           id_name: {type: :string}
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

  path '/{locale}/settings/city' do
    post 'Add city into the system' do
      tags 'Settings'
      consumes 'application/json'
      produces 'application/json'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :params, in: :body, schema: {
          type: :object,
          properties: {
              country_id: { type: :integer },
              name:      { type: :string },
              city_code: { type: :string }
          }
      }
      response '201', 'ok' do
        schema type: :object,
               properties: {
                   city: {
                       type: :object,
                       properties: {
                           id: { type: :integer },
                           name: { type: :string },
                           city_code: { type: :string },
                           country_id:   { type: :integer }
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

  path '/{locale}/settings/countries' do
    get 'Returns countries' do
      tags 'Settings'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })
      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      response '200', 'OK' do
        schema type: :object,
               properties: {
                   countries: {
                       type: :array,
                       items: {
                           properties: {
                               id:   { type: :integer },
                               name: { type: :string },
                               country_code: { type: :string }
                           }

                       }
                   }
               }

        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {}
        run_test!
      end

    end
  end

  path '/{locale}/settings/cities' do
    get 'Returns cities' do
      tags 'Settings'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })
      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :country_id,     in: :query,  type: :integer,  required: true

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   cities: {
                       type: :array,
                       items: {
                           properties: {
                               id:   { type: :integer },
                               name: { type: :string },
                               city_code: { type: :string },
                               country_id: { type: :integer }
                           }

                       }
                   }
               }

        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {}
        run_test!
      end

    end
  end

  path '/{locale}/settings/machine_models' do
    get 'Returns machine models' do
      tags 'Settings'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })
      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   machine_models: {
                       type: :array,
                       items: {
                           properties: {
                               id:   { type: :integer },
                               name: { type: :string },
                               id_name: { type: :string }
                           }

                       }
                   }
               }

        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {}
        run_test!
      end

    end
  end

  path '/{locale}/settings/tool_models' do
    get 'Returns tool models' do
      tags 'Settings'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })
      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   tool_models: {
                       type: :array,
                       items: {
                           properties: {
                               id:   { type: :integer },
                               name: { type: :string },
                               id_name: { type: :string }
                           }

                       }
                   }
               }

        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {}
        run_test!
      end

    end
  end

  path '/{locale}/settings/external_source_types' do
    get 'Returns external types models' do
      tags 'Settings'
      consumes 'application/json'

      parameter({
                    :in => :header,
                    :type => :string,
                    :name => :Authorization,
                    :required => true,
                    :description => 'Client token'
                })
      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"

      response '200', 'OK' do
        schema type: :object,
               properties: {
                   external_source_types: {
                       type: :array,
                       items: {
                           properties: {
                               id:   { type: :integer },
                               name: { type: :string },
                               id_name: { type: :string }
                           }

                       }
                   }
               }

        run_test!
      end

      response '404', 'Not found' do
        schema type: :object,
               properties: {}
        run_test!
      end

    end
  end

  path '/{locale}/settings/destroy_country' do
    delete 'delete country' do
      tags 'Settings'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :id,     in: :query,  type: :integer,  required: true

      response '204', 'OK' do

        schema type: :object,
               properties: {
                   success: { type: :boolean}
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end
    end
  end

  path '/{locale}/settings/destroy_city' do
    delete 'delete city' do
      tags 'Settings'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :id,     in: :query,  type: :integer,  required: true

      response '204', 'OK' do

        schema type: :object,
               properties: {
                   success: { type: :boolean}
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end
    end
  end

  path '/{locale}/settings/destroy_machine_model' do
    delete 'delete city' do
      tags 'Settings'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :id,     in: :query,  type: :integer,  required: true

      response '204', 'OK' do

        schema type: :object,
               properties: {
                   success: { type: :boolean}
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end
    end
  end

  path '/{locale}/settings/destroy_tool_model' do
    delete 'delete city' do
      tags 'Settings'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :id,     in: :query,  type: :integer,  required: true

      response '204', 'OK' do

        schema type: :object,
               properties: {
                   success: { type: :boolean}
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end
    end
  end

  path '/{locale}/settings/destroy_external_source_type' do
    delete 'delete city' do
      tags 'Settings'
      consumes 'multipart/form-data'

      parameter({
                    in: :header,
                    type: :string,
                    name: :Authorization,
                    required: true,
                    description: 'JWT token'
                })

      parameter name: :locale, in: :path,  type: :string,  required: true, default: "en"
      parameter name: :id,     in: :query,  type: :integer,  required: true

      response '204', 'OK' do

        schema type: :object,
               properties: {
                   success: { type: :boolean}
               }

        run_test!
      end

      response '404', 'Not Found' do

        run_test!
      end
    end
  end
end


