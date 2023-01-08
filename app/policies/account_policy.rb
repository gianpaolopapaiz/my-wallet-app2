class AccountPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(user:)
    end
  end

  def show?
    record.user == user
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

  def ofx_import?
    record.user == user
  end

  def ofx_import_to_account?
    record.user == user
  end
end
