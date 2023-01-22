module Api
  module V1
    class CategoriesController < Api::ApplicationController
      before_action :authenticate_user!
      before_action :set_category, only: %i[show update destroy]

      def index
        @categories = current_user.categories
        render json: @categories, status: :ok
      end

      def show
        render json: @category, status: :ok
      end

      def create
        @category = current_user.categories.new(category_params)
        if @category.save
          render json: @category, status: :created
        else
          render_error_message(@category)
        end
      end

      def update
        if @category.update(category_params)
          render json: @category, status: :ok
        else
          render_error_message(@category)
        end
      end

      def destroy
        if @category.destroy
          render json: { message: 'Category successfully destroyed' }, status: :ok
        else
          render_error_message(@category)
        end
      end

      private

      def category_params
        params.require(:category).permit(:name, :description, :user)
      end

      def set_category
        @category = current_user.categories.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render_unauthorized_message
      end
    end
  end
end