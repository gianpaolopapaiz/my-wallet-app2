module Api
  module V1
    class AccountsController < Api::ApplicationController
      before_action :authenticate_user!
      before_action :set_account, only: %i[show update destroy]

      def index
        @accounts = current_user.accounts
        render json: @accounts, status: :ok
      end

      def show
        render json: @account, status: :ok
      end

      def create
        @account = current_user.accounts.new(account_params)
        if @account.save
          render json: @account, status: :created
        else
          render_error_message(@account)
        end
      end

      def update
        if @account.update(account_params)
          render json: @account, status: :ok
        else
          render_error_message(@account)
        end
      end

      def destroy
        if @account.destroy
          render json: { message: 'Account successfully destroyed' }, status: :ok
        else
          render_error_message(@account)
        end
      end

      private

      def account_params
        params.require(:account).permit(:name, :description, :initial_amount)
      end

      def set_account
        @account = current_user.accounts.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_unauthorized_message
      end
    end
  end
end