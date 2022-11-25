class SubcategoriesController < ApplicationController
  before_action :set_category, only: %i[index new create]
  before_action :set_subcategory, only: %i[edit update destroy]

  def index
    @subcategories = policy_scope(Subcategory).where(category: @category).order(name: :desc)
    respond_to do |format|
      format.html
      format.json { render json: @subcategories }
    end
  end

  def new
    @subcategory = @category.subcategories.new
    authorize @subcategory
  end

  def create
    @subcategory = @category.subcategories.new(subcategories_params)
    if @subcategory.save
      redirect_to categories_path(@category)
    else
      render :new
    end
  end

  def edit
    @category = @subcategory.category
  end

  def update
    if @subcategory.update(subcategories_params)
      redirect_to categories_path
    else
      render :edit
    end
  end

  def destroy
    @subcategory.destroy
    redirect_to categories_path, status: :see_other
  end

  private

  def subcategories_params
    params.require(:subcategory).permit(:name, :description)
  end

  def set_category
    @category = current_user.categories.find(params[:category_id])
    authorize @category
  end

  def set_subcategory
    @subcategory = current_user.subcategories.find(params[:id])
    authorize @subcategory
  end
end
