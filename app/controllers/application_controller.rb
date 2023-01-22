class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # Pundit: allow-list approach
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(root_path)
  end

  def set_transaction_filter(params)
    # Filters
    # Date
    @start_date = Date.today.at_beginning_of_year
    @end_date = Date.today.at_end_of_month
    @end_of_year = Date.today.at_end_of_year
    if !params[:start_date].blank? && !params[:end_date].blank?
      @start_date = params[:start_date]
      @end_date = params[:end_date]
    end
    @transactions = @transactions.filter_by_date(@start_date, @end_date)
    # Payment Type
    if params[:payment_type] == 'Income'
      @transactions = @transactions.filter_by_income
      @payment_type = 'Income'
    end
    if [nil, 'expense'].include?(params[:payment_type])
      @transactions = @transactions.filter_by_expense
      @payment_type = 'Expense'
    end
    # Category
    @category_id = nil
    if !params[:category].blank? && params[:category].to_i >= 0
      @category_id = params[:category]
      @transactions = @transactions.filter_by_category(@category_id)
    end
    # Account
    @account_id = nil
    if !params[:account].blank? && params[:account].to_i >= 0
      @transactions = @transactions.where('account_id = :account_id', account_id: params[:account])
      @account_id = params[:account]
    end
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end

  protected

  def configure_permitted_parameters
    # For additional fields in app/views/devise/registrations/new.html.erb
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])

    # For additional in app/views/devise/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name])
  end
end
