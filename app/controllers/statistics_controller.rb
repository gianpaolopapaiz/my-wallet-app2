class StatisticsController < ApplicationController
  def index
    @transactions = policy_scope(Transaction)
    params[:payment_type] ||= session[:payment_type] || "Expense"
    set_transaction_filter(params)
    @transactions_total = @transactions.sum(:value)
    @transactions_by_category = @transactions.joins(:category)
                                             .group('categories.name')
                                             .order('categories.name')
                                             .sum('transactions.value')
    @transactions_by_week = @transactions.group_by_week(:date).sum(:value)
    @transactions_by_month = @transactions.group_by_month(:date, format: '%b').sum(:value)
  end
end
