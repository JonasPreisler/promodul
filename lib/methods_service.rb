module MethodsService
  def current_account
    return nil unless request.headers['Authorization']
    user_id = get_user_id
    @current_account ||= UserAccount.find(user_id)
  end

  def current_customer
    customer_id = request.params[:customer_id]
    account = current_account
    customer = account.umg_customers.where(id: customer_id).first
    inactive_customer_response if customer.present? && !customer.active
    customer ||  account_customer
  end

  #def account_customer
  #  Customer.find_by(umg_user_account_id: current_account.id, umg_customer_type_id: Umg::CustomerType.find_by_id_name(:account).id)
  #end

  def user_for_paper_trail
    current_account&.id
  end

  def respond_service(service)
    if service.errors.any?
      render json: { error: service.errors }, status: :internal_server_error
    else
      render json: { data: service.respond_to?(:json_view) ? service.json_view : nil }, status: :ok
    end
  end

  def inactive_customer_response
    render :json => {status_code: 5, field: :base, message: I18n.t("custom.errors.validation.inactive_customer")}, status: 404
  end

  def validate_authentication
    result = Jwt::ValidateTokenService.new(bearer_token).call

    unless result.valid?
      render :json => {}, status: 401
      false
    end
  end

  def is_super_admin?
    if current_account.user_role.role_group.id_name != "super_admin"
      render :json => {permission_dined: "You don't have access to this functionality"}, status: 401
      false
    end
  end

  def is_project_manager?
    if current_account.user_role.role_group.id_name != "project_manager"
      render :json => {permission_dined: "You don't have access to this functionality"}, status: 401
      false
    end
  end

  def is_employee?
    if current_account.user_role.role_group.id_name != "employee"
      render :json => {permission_dined: "You don't have access to this functionality"}, status: 401
      false
    end
  end

  #def validate_policy_and_terms
  #  service = Umg::AgreementService.new(current_account)
  #  service.agreement_info
  #  result = service.agreements_info_json_view
  #  valid_agreements = result[:privacy_policy] && result[:terms_and_conditions]
  #  render json: {status_code: 5, field: :error, error_msg: I18n.t("custom.errors.validation.invalid_agreements")}, status: 400 unless valid_agreements
  #end

  def bearer_token
    pattern = /^Bearer /
    header  = request.headers["Authorization"]
    header.gsub(pattern, '') if header&.match(pattern)
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  private

  def get_user_id
    payload = Base64.decode64(token.split('.').second)
    JSON.parse(payload)['user_id']
  end

  def token
    pattern = /^Bearer /
    token = request.headers['Authorization']
    token.gsub(pattern,"") if token&.match(pattern)
  end
end