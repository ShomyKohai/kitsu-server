# frozen_string_literal: true

class MangaPolicy < ApplicationPolicy
  administrated_by :database_mod

  class Scope < Scope
    def resolve
      if user && !user.sfw_filter?
        scope
      else
        scope.sfw
      end
    end
  end

  class TypesensualScope < TypesensualScope
    def resolve
      if user && !user.sfw_filter?
        search
      else
        search.filter('age_rating:!=[R18]')
      end
    end
  end
end
