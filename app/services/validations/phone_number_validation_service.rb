module Validations
  class PhoneNumberValidationService
    include Validations::PhoneNumberValidation
    include ErrorsFormat
    attr_reader :country_index, :errors

    def initialize(service, phone_number, phone_number_iso)
      @service = service
      @phone_number = phone_number
      @phone_number_iso = phone_number_iso
    end

    def validate
      validate_phone_number_iso
      validate_phone_number
    end

    def validate_phone_number_iso
      return if @service.errors.any?
      iso_code = @phone_number_iso.to_s.upcase
      @country_index = CountryPhoneIndex.find_by(iso_code: iso_code)
      fill_custom_errors(@service,:phone_number_iso, :not_found, I18n.t("custom.errors.validation.phone_number_iso")) unless @country_index&.phone_index.present?
    end

    def validate_phone_number
      return if @service.errors.any?
      fill_custom_errors(@service, :phone_number, :invalid, I18n.t('custom.errors.validation.empty_phone_number')) && return unless @phone_number.present?
      phone_number = @phone_number
      phone_number_iso = @country_index.iso_code
      number_length = @country_index&.length_limit || 20
      valid_number_length = valid_phone_number_length?(phone_number,{phone_number_iso: phone_number_iso})
      valid_phone_number_format = valid_phone_number_format?(phone_number)
      unless valid_number_length
        message = "valid_phone_number_length"
        fill_custom_errors(@service,:phone_number, :invalid, I18n.t("custom.errors.validation.#{message}?", {length: number_length}))
        return
      end
      fill_custom_errors(@service,:phone_number, :invalid, I18n.t("custom.errors.validation.valid_phone_number_format?")) unless valid_phone_number_format
    end
  end
end