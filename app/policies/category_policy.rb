# frozen_string_literal: true

class CategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user:)
    end
  end

  def new?
    record.user == user
  end

  def create?
    record.user == user
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  # Subcategory's index
  def index?
    record.user == user
  end
end
