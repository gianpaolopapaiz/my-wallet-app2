class CategoriesController < ApplicationController
  before_action :set_category, only: %i[edit update destroy]

  def index
    @categories = policy_scope(Category).order(name: :asc)
  end

  def new
    @category = current_user.categories.new
    authorize @category
  end

  def create
    @category = current_user.categories.new(categories_params)
    authorize @category
    if @category.save
      redirect_to categories_path,
                  notice: 'Category was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(categories_params)
      redirect_to categories_path,
                  notice: 'Category was successfully updated.'
    else
      render :new
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path,
                alert: 'Category was successfully deleted.'
  end

  private

  def categories_params
    params.require(:category).permit(:name, :description)
  end

  def set_category
    @category = current_user.categories.find(params[:id])
    authorize @category
  end
end
