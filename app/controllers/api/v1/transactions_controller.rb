module Api
  module V1
    class TransactionsController < Api::ApplicationController
      before_action :authenticate_user!
      before_action :set_account_and_transaction

      def index
        @transactions = @account.transactions
        render json: @transactions, status: :ok
      end

      def show
        render json: @transaction, status: :ok
      end

      def create
        @transaction = @account.transactions.new(transaction_params)
        if @transaction.save
          render json: @transaction, status: :created
        else
          render_error_message(@transaction)
        end
      end

      def update
        if @transaction.update(transaction_params)
          render json: @transaction, status: :ok
        else
          render_error_message(@transaction)
        end
      end

      def destroy
        if @transaction.destroy
          render json: { message: 'Transaction successfully destroyed' }, status: :ok
        else
          render_error_message(@transaction)
        end
      end

      private

      def transaction_params
        params.require(:transaction).permit(:name,
                                            :description,
                                            :value,
                                            :date,
                                            :category_id,
                                            :subcategory_id,
                                            :account_id)
      end

      def set_account_and_transaction
        @account = current_user.accounts.find(params[:account_id])
        @transaction = @account.transactions.find(params[:id]) if params[:id]
      end
    end
  end
end