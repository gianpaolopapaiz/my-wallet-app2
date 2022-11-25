class TransactionsController < ApplicationController
  before_action :set_account, only: %i[new create]
  before_action :set_transaction_and_account, only: %i[show edit update destroy]

  def show
    respond_to do |format|
      format.html
      format.json { render json: @transaction }
    end
  end

  def new
    @transaction = @account.transactions.new
    authorize @transaction
  end

  def create
    @transaction = @account.transactions.new(transactions_params)
    if @transaction.save
      redirect_to account_path(@account),
                  notice: 'Transaction was successfully created.'

    else
      render :new
    end
  end

  def edit; end

  def update
    if @transaction.update(transactions_params)
      redirect_to account_path(@account),
                  notice: 'Transaction was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @transaction.destroy
    redirect_to account_path(@account),
                alert: 'Transaction was successfully deleted.',
                status: :see_other
  end

  private

  def transactions_params
    params.require(:transaction).permit(:date,
                                        :name,
                                        :description,
                                        :value,
                                        :category_id,
                                        :subcategory_id)
  end

  def set_account
    @account = current_user.accounts.find(params[:account_id])
    authorize @account
  end

  def set_transaction_and_account
    @transaction = Transaction.find(params[:id])
    authorize @transaction
    @account = @transaction.account
    authorize @account
  end
end
