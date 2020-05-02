module ConditionsHelper
    def count_favorites(condition)
        condition.favorites.count
    end
end
