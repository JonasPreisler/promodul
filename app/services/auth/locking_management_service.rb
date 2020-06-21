# DHP-122
module Auth
  class LockingManagementService

    attr_reader :authenticated_user, :user_name, :user_by_name, :login_attempt_limit, :login_time_limit, :max_attempt, :seconds_in_one_hour, :user_to_check, :status_code

    def initialize(authenticated_user, user_name = nil, user_by_name = nil)
      @authenticated_user = authenticated_user
      @user_name = user_name
      @user_by_name = user_by_name || UserAccount.where(username: user_name).or(UserAccount.where(phone_number: user_name)).where(active: true).first

      @user_to_check = authenticated_user || user_by_name

      if @user_to_check.present?
        @login_attempt_limit = LOGIN_FAILURE_SETTINGS.has_key?(@user_to_check.failed_logins_count)
        @login_time_limit = LOGIN_FAILURE_SETTINGS[@user_to_check.failed_logins_count] if login_attempt_limit
      end


      @max_attempt = LOGIN_FAILURE_SETTINGS.key("forever")

      @seconds_in_one_hour = SECONDS_IN_ONE_HOUR
    end

    def invalid_user_error_message

      if authenticated_user_valid?
        stop_failure_counting
        nil
      else
        locked_user_error_message
      end

    end

    # return an error message if something went wrong
    def locked_user_error_message

      locker_type_id = LockingType.find_by_id_name(:password_error_limited).try(:id)
      if authenticated_user.present? &&  @user_by_name.locked && @user_by_name.umg_locking_type_id != locker_type_id
        error_msg = I18n.t('errors.auth.blocked_by_ekimo')
      elsif authenticated_user.nil? && @user_by_name.present? && @user_by_name.locked && @user_by_name.umg_locking_type_id != locker_type_id
        error_msg = I18n.t('errors.auth.wrong_credentials')
      else

        if locked_by_invalid_pass?
          error_msg = I18n.t('errors.final_security_error')
          @status_code = :forbidden
        elsif auth_user_invalid_or_locked_by_pass?
          error_msg = tempo_locked_message
        else
          error_msg = I18n.t('errors.auth.wrong_credentials')
        end
      end

      error_msg
    end

    def tempo_locked_message
      error_msg = nil

      user_is_locked_for = has_failed_attempts?
      if user_is_locked_for.present? && user_is_locked_for > 0
        time_unit_text  = user_is_locked_for == 1 ? I18n.t('errors.time_unit') : I18n.t('errors.time_unit_plural')
        error_msg =   I18n.t('errors.security_error', hours: user_is_locked_for, time_unit: time_unit_text)
        @status_code = :forbidden
      elsif user_is_locked_for.present? && user_is_locked_for == -1
        error_msg = I18n.t('errors.final_security_error')
        @status_code = :forbidden
      elsif authenticated_user.nil?
        error_msg = I18n.t('errors.auth.wrong_credentials')
      end

      error_msg
    end

    # locks an account and returns its locking duration
    # returns number of hours if it is temporary blocked
    # returns -1 if it is blocked forever
    # returns nil if user have more tries to login
    def lock_user
      update_user_by_name(login_time_limit == 'forever' && !user_by_name.locked) if continue_counting?
      current_login_time_limit = LOGIN_FAILURE_SETTINGS[user_by_name.failed_logins_count]

      tempo_locked?(current_login_time_limit) ? current_login_time_limit/seconds_in_one_hour : (user_finally_locked? ? -1 : nil)
    end

    # unlocks and account
    def stop_failure_counting
      authenticated_user.failed_logins_count = 0
      authenticated_user.last_attempt_date = nil
      authenticated_user.save!

    rescue => e
      Rails.logger.error("Method: #{ __method__ }, Error: #{ e }")

    end

    def update_user_by_name(should_lock)

      user_by_name.failed_logins_count += 1
      if should_lock
        user_by_name.locked = true
        locker_type_id = LockingType.find_by_id_name(:password_error_limited).try(:id)
        user_by_name.umg_locking_type_id = locker_type_id
      end
      user_by_name.last_attempt_date = DateTime.now
      user_by_name.save!
    end

    # returns accounts locking duration
    def has_failed_attempts?
      lock_user
    rescue => e
      Rails.logger.error("Method: #{ __method__ }, Error: #{ e }")
    end

    def tempo_locked?(current_login_time_limit)
      current_login_time_limit.present? && login_failure_timed_out?(true) && current_login_time_limit != 'forever'
    end

    def continue_counting?
      failure_counting_continuation = !user_by_name.locked && login_time_limit != 'forever'
      currently_locked = login_time_limit == 'forever' && !user_by_name.locked
      continue_counting = !login_failure_timed_out?(true) && failure_counting_continuation

      continue_counting || currently_locked
    end

    def user_finally_locked?
      user_by_name &&  login_time_limit.present? && login_time_limit == 'forever' && user_by_name.locked
    end

    def authenticated_user_valid?
      authenticated_user && authenticated_user.active? #&& !authenticated_user.locked && authenticated_users_lock_is_expired?
    end

    # account was locked but now lock is expired
    # counting_is_started failures is counting but an account isn't locked yet
    #def authenticated_users_lock_is_expired?
    #  counting_is_started = authenticated_user && authenticated_user.failed_logins_count > 0 && authenticated_user.failed_logins_count < max_attempt && !login_attempt_limit
    #  counting_is_started || login_failure_timed_out? || (authenticated_user && authenticated_user.failed_logins_count == 0)
    #end

    def login_failure_timed_out?(should_lock = false)
      if login_time_limit.present? &&  user_to_check.present? && login_time_limit != 'forever'
        timed_out = should_lock ? user_to_check.last_attempt_date + login_time_limit.seconds > DateTime.now : user_to_check.last_attempt_date + login_time_limit.seconds < DateTime.now
      end
      timed_out
    end

    def locked_by_invalid_pass?
      locker_type_id = LockingType.find_by_id_name(:password_error_limited).try(:id)
      user_to_check && user_to_check.locked && user_to_check.umg_locking_type_id == locker_type_id
    end

    def auth_user_invalid_or_locked_by_pass?
      (authenticated_user.nil? && user_by_name.present?) || ( authenticated_user && !authenticated_user.locked && authenticated_user.failed_logins_count > 0)
    end
  end
end
