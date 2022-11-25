class AccountsController < ApplicationController
  before_action :set_account, only: %i[show edit update destroy ofx_import ofx_import_to_account]

  def index
    @accounts = policy_scope(Account).order(:name)
    @accounts_total_balance = @accounts.collection_balance
  end

  def show
    @transactions = @account.transactions.order(date: :desc)
    set_transaction_filter(params)
    @transactions_count = @transactions.count
  end

  def new
    @account = current_user.accounts.new
    authorize @account
  end

  def create
    @account = current_user.accounts.new(accounts_params)
    authorize @account
    if @account.save
      redirect_to accounts_path,
                  notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @account.update(accounts_params)
      redirect_to accounts_path,
                  notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @account.destroy
    redirect_to accounts_path,
                alert: 'Account was successfully deleted.'
  end

  def ofx_import; end

  def ofx_import_to_account
    wallet_account = @account
    ofx_file = params[:account][:ofx_file]
    OFX(ofx_file) do
      account.transactions.each do |ofx_transaction|
        wallet_transaction = wallet_account.transactions.new(name: ofx_transaction.memo,
                                                             check_number: ofx_transaction.check_number,
                                                             date: ofx_transaction.posted_at,
                                                             value: ofx_transaction.amount)
        wallet_transaction.save!
      end
    end
    redirect_to account_path(@account)
  end

  private

  def accounts_params
    params.require(:account).permit(:name, :description, :initial_amount)
  end

  def set_account
    id = params[:id] || params[:account_id]
    @account = current_user.accounts.find(id)
    authorize @account
  end
end
