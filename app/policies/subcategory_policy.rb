# frozen_string_literal: true

class SubcategoryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
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
end
